# coding: utf-8

require 'net/imap'
require 'yaml'
require 'pp'
require 'kconv'
require 'date'

config = YAML.load_file('config.yml')
c = config['config']

host     = c['host']
user     = c['user']
password = c['password']

imap = Net::IMAP.new(host)
imap.authenticate(c['auth_type'], user, password)
imap.select('INBOX')

def stripSpam(inEncodedSubject)
	original = inEncodedSubject
	striped = inEncodedSubject.gsub(/^\[spam\] /,'')

	return striped if original == striped

	stripSpam striped
end

target_day = DateTime.now - c['days_before']

rule = [
	'BEFORE',
	Time.mktime(
		target_day.year,
		target_day.month,
		target_day.day
		).strftime('%d-%b-%Y')	
	]

result = imap.search(rule)

puts "対象: #{result.count}"

while (message_ids = result.slice!(0,50)).count > 0
	heads = imap.fetch(message_ids, ["ENVELOPE"])
	heads.each do |head|
		subject = head.attr['ENVELOPE'].subject
		if subject == nil then
			puts '[NO SUBJECT]'
		else
			begin
				subject = stripSpam subject
				puts subject.toutf8
			rescue
				puts "CATCH ERROR!!!!"
			end
		end
	end
	imap.store(message_ids, "+FLAGS", [:Deleted])
	message_ids.clear
end


imap.expunge
imap.disconnect

