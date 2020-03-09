-- 1.Find the names of all reviewers who rated Gone with the Wind. 

 select distinct name
 from Reviewer join Rating using (rID) join Movie using (mID)
 where title = 'Gone with the Wind';

-- 2.For any rating where the reviewer is the same as the director of the movie, 
--   return the reviewer name, movie title, and number of stars. 

 select name, title, stars
 from Rating join Movie using (mID) join Reviewer using (rID)
 where Movie.director = Reviewer.name;

-- 3.Return all reviewer names and movie names together in a single list, alphabetized. 
--   (Sorting by the first name of the reviewer and first word in the title is fine; 
--   no need for special processing on last names or removing "The".) 

 select name from Reviewer
 union
 select title from Movie
 order by name ASC;

-- 4.Find the titles of all movies not reviewed by Chris Jackson. 

 select title
 from Movie
 where mID not in (
 select mID from rating join Reviewer using (rID) where name = 'Chris Jackson');

-- 5.For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. 
--   Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. 
--   For each pair, return the names in the pair in alphabetical order. 

 select distinct Re1.name, Re2.name
 from Reviewer Re1, Reviewer Re2, Rating R1, Rating R2, Movie join Rating using (mID)
 where 
 R1.mID = R2.mID and Re1.rID = R1.rID
 and Re2.rID = R2.rID and Re1.name < Re2.name
 order by Re1.name, Re2.name

-- 6.For each rating that is the lowest (fewest stars) currently in the database, 
--   return the reviewer name, movie title, and number of stars. 

 select name, title, stars
 from Movie join Rating using (mID) join Reviewer using (rID)
 where stars = (select min(stars) from Rating)

-- 7.List movie titles and average ratings, from highest-rated to lowest-rated. 
--   If two or more movies have the same average rating, list them in alphabetical order. 

 select title, avg(stars)
 from Movie join Rating using (mID)
 group by mID
 order by avg(stars) DESC, title;

-- 8.Find the names of all reviewers who have contributed three or more ratings. 
--   (As an extra challenge, try writing the query without HAVING or without COUNT.) 

 select name
 from Reviewer
 where (select count(stars) from Rating where Rating.rID = Reviewer.rID ) >= 3;
 
 Others:
 SELECT name
 FROM Reviewer
 INNER JOIN Rating USING(rId)
 GROUP BY rId
 HAVING COUNT(*) >= 3;

 SELECT name
 FROM Reviewer
 WHERE (SELECT COUNT(DISTINCT mId) FROM Rating WHERE Rating.rId = Reviewer.rId) >= 3;
 
-- 9.Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. 
--   (As an extra challenge, try writing the query both with and without COUNT.) 

 select title, director
 from Movie M1
 where (select count(*) from Movie M2 where M1.director = M2.director) > 1
 order by director, title

 Other:
 SELECT M1.title, director
 FROM Movie M1
 INNER JOIN Movie M2 USING(director)
 GROUP BY M1.mId
 HAVING COUNT(*) > 1
 ORDER BY director, M1.title;

-- 10.Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. 
--    (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as 
--     finding the highest average rating and then choosing the movie(s) with that average rating.) 

 select title, avg(stars) as average
 from Movie join Rating using (mID)
 group by mID
 Having average = 
 (
 select max(avg_stars) 
 from  (
 select title, avg(stars) as avg_stars
 from Rating join Movie using (mID) 
 group by mID)
 )

-- 11.Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write in SQLite than other systems; 
--    you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.) 

 select title, avg(stars) as average
 from Movie join Rating using (mID)
 group by mID
 Having average = 
 (
 select min(avg_stars) 
 from  (
 select title, avg(stars) as avg_stars
 from Rating join Movie using (mID) 
 group by mID)
 )

-- 12.For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, 
--    and the value of that rating. Ignore movies whose director is NULL. 

 select director, title, max(stars)
 from Movie join Rating using (mID)
 where director is not null
 group by director
