# KMDB - Kellogg Movie Database
# HW2 - Ruby on Rails version

# 1. Delete existing data
Studio.destroy_all
Movie.destroy_all
Actor.destroy_all
Role.destroy_all
Agent.destroy_all

# 2. Insert Studio
new_studio = Studio.new
new_studio["name"] = "Warner Bros."
new_studio.save
warner = Studio.find_by({ "name" => "Warner Bros." })

# 3. Insert Movies (Using studio["id"] to avoid hard-coded IDs)
movies_list = [
  { title: "Batman Begins", year: 2005, rating: "PG-13" },
  { title: "The Dark Knight", year: 2008, rating: "PG-13" },
  { title: "The Dark Knight Rises", year: 2012, rating: "PG-13" }
]

for m_data in movies_list
  movie = Movie.new
  movie["title"] = m_data[:title]
  movie["year_released"] = m_data[:year]
  movie["mpaa_rating"] = m_data[:rating]
  movie["studio_id"] = warner["id"]
  movie.save
end

# 4. Insert Actors
actor_names = [
  "Christian Bale", "Michael Caine", "Liam Neeson", "Katie Holmes", "Gary Oldman", 
  "Heath Ledger", "Aaron Eckhart", "Maggie Gyllenhaal", "Tom Hardy", 
  "Joseph Gordon-Levitt", "Anne Hathaway"
]

for name in actor_names
  actor = Actor.new
  actor["name"] = name
  actor.save
end

# 5. Insert Roles (Many-to-Many relationship)
begins = Movie.find_by({ "title" => "Batman Begins" })
dk = Movie.find_by({ "title" => "The Dark Knight" })
dkr = Movie.find_by({ "title" => "The Dark Knight Rises" })

roles_data = [
  { movie: begins, actor: "Christian Bale", character: "Bruce Wayne" },
  { movie: begins, actor: "Michael Caine", character: "Alfred" },
  { movie: begins, actor: "Liam Neeson", character: "Ra's Al Ghul" },
  { movie: begins, actor: "Katie Holmes", character: "Rachel Dawes" },
  { movie: begins, actor: "Gary Oldman", character: "Commissioner Gordon" },
  { movie: dk, actor: "Christian Bale", character: "Bruce Wayne" },
  { movie: dk, actor: "Heath Ledger", character: "Joker" },
  { movie: dk, actor: "Aaron Eckhart", character: "Harvey Dent" },
  { movie: dk, actor: "Michael Caine", character: "Alfred" },
  { movie: dk, actor: "Maggie Gyllenhaal", character: "Rachel Dawes" },
  { movie: dkr, actor: "Christian Bale", character: "Bruce Wayne" },
  { movie: dkr, actor: "Gary Oldman", character: "Commissioner Gordon" },
  { movie: dkr, actor: "Tom Hardy", character: "Bane" },
  { movie: dkr, actor: "Joseph Gordon-Levitt", character: "John Blake" },
  { movie: dkr, actor: "Anne Hathaway", character: "Selina Kyle" }
]

for r in roles_data
  new_role = Role.new
  new_role["movie_id"] = r[:movie]["id"]
  new_role["actor_id"] = Actor.find_by({ "name" => r[:actor] })["id"]
  new_role["character_name"] = r[:character]
  new_role.save
end

# 6. Assign Agent (Requirement 4)
new_agent = Agent.new
new_agent["name"] = "Ari Emanuel"
new_agent.save

bale = Actor.find_by({ "name" => "Christian Bale" })
bale["agent_id"] = new_agent["id"]
bale.save

# --- PRINT REPORTS ---

puts "Movies"
puts "======"
puts ""

all_movies = Movie.all
for movie in all_movies
  st = Studio.find_by({ "id" => movie["studio_id"] })
  puts "#{movie["title"].ljust(22)} #{movie["year_released"]}  #{movie["mpaa_rating"].ljust(10)} #{st["name"]}"
end

puts ""
puts "Top Cast"
puts "========"
puts ""

all_roles = Role.all
for role in all_roles
  mov = Movie.find_by({ "id" => role["movie_id"] })
  act = Actor.find_by({ "id" => role["actor_id"] })
  puts "#{mov["title"].ljust(22)} #{act["name"].ljust(20)} #{role["character_name"]}"
end

puts ""
puts "Represented by agent"
puts "===================="
puts ""

ari = Agent.find_by({ "name" => "Ari Emanuel" })
represented = Actor.where({ "agent_id" => ari["id"] })
for actor in represented
  puts actor["name"]
end
