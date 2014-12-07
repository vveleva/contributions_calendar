require 'date'
require 'byebug'
# 52 X 7

PATTERN0 = <<-EOF.split("\n").map { |l| l.split('') }.transpose.flatten.join
X--XXXX--X--XXXX--X----X--XXXXX----X--XXXX--XX--XXXX
X--XXXX--X--XXXX--X----X--XXXXX----X--XXXX--XX--XXXX
XX--XX--XXX--XX--XX--XXX--XXXXX--XXXX--XX--XX----XXX
XX--XX--XXX--XX--X-----X--XXXXX-----X--XX--X--XX--XX
XXX----XXXXX----XX--XXXX--XXXXX--XXXXX----XX--XX--XX
XXXX--XXXXXXX--XX------X--XXXXX------XX--XX--XXXX--X
XXXX--XXXXXXX--XX------X------X------XX--XX--XXXX--X
EOF

PATTERN = <<-EOF.split("\n").map { |l| l.split('') }.transpose.flatten.join
-XX---XX-XX---XX-XXXXXX-XXX----XXXXXX-XX---XX--X----
--X---X---X---X---X------X------X------X---X---X----
--XX-XX---XX-XX---X------X------X------XX-XX--XXX---
---X-X-----X-X----XXX----X------XXX-----X-X---X-X---
---XXX-----XXX----X------X------X-------XXX--XX-XX--
----X-------X-----X------X---X--X--------X---X---X--
----X-------X----XXXXXX-XXXXXX-XXXXXX----X--XX---XX-
EOF

MASK = PATTERN.split(//).map{ |c| c == 'X' }

DAYSTART = Date.new(2014, 11, 30)
DAYEND   = DAYSTART + (PATTERN.size) # 2015-12-20

dates = DAYSTART.upto(DAYEND).to_a

def on?(date)
  delta = (date - DAYSTART).to_i
  MASK[ delta % MASK.size ]
end

commit_dates = []
dates.each do |date|
  if on?(date)
    20.times { |i| commit_dates << date.to_time + i * 3600 }
  end
end

str_commit_dates = commit_dates.map(&:to_s)

ignore_dates = [
  Date.new(2015, 2,10).to_time,
  Date.new(2015, 2, 11).to_time,
  Date.new(2015, 2, 12).to_time,
  Date.new(2015, 5, 24).to_time,
  Date.new(2015, 6, 6).to_time,
]

commit_dates.each do |date|
  next if ignore_dates.include?(date)
  next if date - Date.new(2015, 7, 13).to_time >= 0 && date - Date.new(2015, 5, 8).to_time < 0
  # next unless date - Date.new(2014, 12, 23).to_time >= 0 && date - Date.new(2015, 1, 15).to_time < 0
  File.open('random_list_of_dates', 'w') { |f| f << str_commit_dates.shuffle.first(12).join("\n") }
  `GIT_AUTHOR_DATE="#{date}" GIT_COMMITTER_DATE="#{date}" git commit -am "#{date}_#{rand(10 ** 50..9 * 10 ** 50).to_s(36)}"`
end
