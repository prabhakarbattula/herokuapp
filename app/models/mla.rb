require 'open-uri'
class Mla < Seat
  def self.results
    294.times do | i |
      url = "http://eciresults.nic.in/AC/ConstituencywiseS01#{i+1}.htm?ac=#{i+1}"
      page = Nokogiri::HTML(open(url))
      name = page.css("table[style][border] tr:first td").text.split("-").last.strip.titleize
      current_seat = create(name: name)

      page.css("table[style][border] tr:first td").text.split("-").last

      page.css("table[style][border] tr[style='font-size:12px;']").each_with_index  do | seat, index |
        candidate, party, votes = seat.css("td").map(&:text).map(&:titleize)
        party = Party.find_or_create_by(name: party)
        putc '.'
        current_seat.nominations.create(candidate: candidate, party: party, votes: votes.to_i, position: index + 1)
      end
    end
  end
end
