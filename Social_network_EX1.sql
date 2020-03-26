Students at your hometown high school have decided to organize their social network using databases. So far, they have collected information about sixteen students in four grades, 9-12. Here's the schema: 

Highschooler ( ID, name, grade ) 
English: There is a high school student with unique ID and a given first name in a certain grade. 

Friend ( ID1, ID2 ) 
English: The student with ID1 is friends with the student with ID2. Friendship is mutual, so if (123, 456) is in the Friend table, so is (456, 123). 

Likes ( ID1, ID2 ) 
English: The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also present. 

-- 1.Find the names of all students who are friends with someone named Gabriel.

  select H1.name
  from Highschooler H1
  join Friend on Friend.ID1 = H1.ID
  join Highschooler H2 on H2.ID = Friend.ID2
  where H2.name = 'Gabriel'
  
-- 2.For every student who likes someone 2 or more grades younger than themselves, 
   return that student's name and grade, and the name and grade of the student they like.
   
  select H1.name, H1.grade, H2.name, H2.grade
  from Highschooler H1
  join Likes on H1.ID = Likes.ID1
  join Highschooler H2 on H2.ID = Likes.ID2
  where abs(H1.grade - H2.grade) >= 2
  
-- 3.For every pair of students who both like each other, return the name and grade of both students. 
    Include each pair only once, with the two names in alphabetical order. 
    
  select distinct H1.name, H1.grade, H2.name, H2.grade
  from Highschooler H1, Highschooler H2, Likes L1, Likes L2
  where (H1.ID = L1.ID1 and H2.ID = L1.ID2) and (H2.ID = L2.ID1 and H1.ID = L2.ID2) and H1.name < H2.name
  order by H1.name 
  
-- 4.Find all students who do not appear in the Likes table 
    (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade.
    
  select name, grade
  from Highschooler  
  where ID not in (select ID1 from Likes union select ID2 from Likes)
  group by grade, name
  
-- 5.For every situation where student A likes student B, but we have no information about whom B likes 
    (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. 
    
  select distinct H1.name, H1.grade, H2.name, H2.grade
  from Highschooler H1, Highschooler H2, Likes L1, Likes L2
  where (H1.ID = L1.ID1 and H2.ID = L1.ID2) and H2.ID not in(
  select distinct ID1
  from Likes
  )
  
-- 6.Find names and grades of students who only have friends in the same grade. 
   Return the result sorted by grade, then by name within each grade.
   
  select distinct name, grade
  from Highschooler H1
  where ID not in (
  select ID1
  from Highschooler H2, Friend F
  where H1.ID = F.ID1 and H2.ID = F.ID2 and H1.grade <> H2.grade)
  order by grade, name
  
-- 7.For each student A who likes a student B where the two are not friends, find if they have a friend C in common 
   (who can introduce them!). For all such trios, return the name and grade of A, B, and C. 
   
  select distinct H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
  from Highschooler H1, Highschooler H2, Highschooler H3, Likes L, Friend F1, Friend F2
  where (H1.ID = L.ID1 and H2.ID = L.ID2) and H3.ID in (select ID1 from Friend where H1.ID = F1.ID2 and H3.ID = F1.ID1) 
  and H2.ID not in(select ID1 from Friend where H2.ID = F1.ID1 and H3.ID = F1.ID2) 
  order by H1.name, H1.grade 
  
  SELECT DISTINCT H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
  FROM Highschooler H1, Highschooler H2, Highschooler H3, Likes L, Friend F1, Friend F2
  WHERE (H1.ID = L.ID1 AND H2.ID = L.ID2) AND H2.ID NOT IN (
  SELECT ID2
  FROM Friend
  WHERE ID1 = H1.ID
  ) AND (H1.ID = F1.ID1 AND H3.ID = F1.ID2) AND (H2.ID = F2.ID1 AND H3.ID = F2.ID2);
  
-- 8.Find the difference between the number of students in the school and the number of different first names. 

  select count(*)-count(distinct name)
  from Highschooler
  
-- 9.Find the name and grade of all students who are liked by more than one other student. 

  select name, grade
  from Highschooler H join Likes L on H.ID = L.ID2
  group by ID2
  having count(*)>1
















