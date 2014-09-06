--PREAMBLE--
create view bar as select paperid,count(*)n from paperbyauthors group by paperid having count(*)>20;

create view bar1 as select paperid from paperbyauthors group by paperid having count(*)=1;

create view bar2 as select authorid,count(*) c from paperbyauthors group by authorid;

create view bar3 as select venueid from venue where type like 'jour%';

create view v as select authorid from paper,venue,paperbyauthors where type = 'journals' and paper.venueid=venue.venueid and paperbyauthors.paperid=paper.paperid;

create view v1 as select authorid from paper,venue,paperbyauthors where type != 'journals' and paper.venueid=venue.venueid and paperbyauthors.paperid=paper.paperid;

create view bar4 as select author.authorid,year from author,paper,paperbyauthors where author.authorid=paperbyauthors.authorid and paperbyauthors.paperid=paper.paperid group by author.authorid,year having year='2012' and count(*)>=2;

create view bar5 as select author.authorid,year from author,paper,paperbyauthors where author.authorid=paperbyauthors.authorid and paperbyauthors.paperid=paper.paperid group by author.authorid,year having year='2013' and count(*)>=3;

create view bar6 as select venueid from venue where type like 'jour%' and name like 'corr';

create view bar7 as select venueid from venue where type like 'jour%' and name like 'amc';

create view bar8 as select venueid from venue where type like 'jour%' and name like 'ieicet';

create view iei as select author.name from author,paper,paperbyauthors,bar8 where bar8.venueid=paper.venueid and paper.paperid=paperbyauthors.paperid and paperbyauthors.authorid=author.authorid group by author.name having count(*)>=10;

create view bar9 as select venueid from venue where type like 'jour%' and name like 'tcs';

create view tcs as (select name from author except (select author.name from author,paper,paperbyauthors,bar9 where bar9.venueid=paper.venueid and paper.paperid=paperbyauthors.paperid and paperbyauthors.authorid=author.authorid group by author.name));

create view bar20 as select paper2id,count(*) c from citation group by paper2id;

create view bar21 as select paper1id,count(*) n from citation group by paper1id;

create view bar10 as select paperid,title,year,name,venue.venueid from paper,venue where paper.venueid=venue.venueid and type like 'jour%';

create view bar22 as select venueid,name from venue where type='journals';

create view corr as select distinct author.name from author,paper,paperbyauthors,bar6 where bar6.venueid=paper.venueid and paper.paperid=paperbyauthors.paperid and paperbyauthors.authorid=author.authorid group by author.name,paper.year having paper.year>='2009' and paper.year<='2013';

create view ieic as (select name from author except (select distinct author.name from author,paper,paperbyauthors,bar8 where bar8.venueid=paper.venueid and paper.paperid=paperbyauthors.paperid and paperbyauthors.authorid=author.authorid group by author.name,paper.year having paper.year='2009'));

create view sa1 as select (paperbyauthors.authorid) c,paper1id,paper2id from citation,paperbyauthors where citation.paper1id=paperbyauthors.paperid;

create view sa2 as select c,paper1id,paper2id,(paperbyauthors.authorid) d from sa1,paperbyauthors where sa1.paper2id=paperbyauthors.paperid;

create view jy as select name,year,count(*) se from bar10 group by name,year ;

create view ba1 as select name,year,count(paperid) from venue,paper where venue.venueid=paper.venueid and type ilike 'journals' and year>='2009' and year <= '2013' group by name,year;

create view ba2 as select name,year,count(paperid) from venue,paper where venue.venueid=paper.venueid and type ilike 'journals' and year>='2009' and year <= '2013' group by name,year;

create view ba3 as select distinct name from venue,paper where venue.venueid=paper.venueid and type ilike 'journals' and year='2009';

--1--
select type,count(*) from venue,paper where venue.venueid=paper.venueid group by type order by count(*) desc;

--2--
select avg(foo.n) from (select paperid,count(*)n from paperbyauthors group by paperid) as foo;

--3--
select title from paper,bar where bar.paperid=paper.paperid order by title;

--4--
(select name from author except select author.name from author, paperbyauthors,bar1 where bar1.paperid=paperbyauthors.paperid and paperbyauthors.authorid=author.authorid) order by name;

--5--
select name from author,bar2 where author.authorid=bar2.authorid order by c desc,name limit 20;

--6--
select name from author,(select authorid from (select authorid,bar1.paperid from paperbyauthors,bar1 where bar1.paperid=paperbyauthors.paperid) as foo1 group by authorid having count(*)>100) as foobar where foobar.authorid=author.authorid order by name;

--7--
(select name from author except (select distinct author.name from author,paper,paperbyauthors,bar3 where bar3.venueid=paper.venueid and paper.paperid=paperbyauthors.paperid and paperbyauthors.authorid=author.authorid)) order by name;

--8--
select name from author,(select authorid from v except select authorid from v1) as fo where author.authorid=fo.authorid order by name;

--9--
select name from author,(select bar5.authorid from bar4,bar5 where bar4.authorid=bar5.authorid) as foo3 where foo3.authorid=author.authorid order by name;

--10--
select name from author,(select paperbyauthors.authorid,count(*) c from paper,paperbyauthors,bar6 where bar6.venueid=paper.venueid and paper.paperid=paperbyauthors.paperid group by paperbyauthors.authorid) as frw where frw.authorid=author.authorid  order by frw.c desc limit 20;

--11--
select name from author,(select distinct paperbyauthors.authorid from paper,paperbyauthors,bar7 where bar7.venueid=paper.venueid and paper.paperid=paperbyauthors.paperid group by paperbyauthors.authorid having count(*)>=4) as fr
where fr.authorid=author.authorid order by author.name;

--12--
select tcs.name from tcs,iei where iei.name=tcs.name order by tcs.name;

--13--
select year,count(*) c from paper group by year having year>='2004' and year<='2013' order by year;

--14--
select distinct name from author,paperbyauthors,(select paperid from paper where title ilike '%query optimization%') as fre where fre.paperid=paperbyauthors.paperid and paperbyauthors.authorid=author.authorid order by name;

--15--
select title from paper,(select paper2id,count(*) c from citation group by paper2id) as fin where fin.paper2id=paper.paperid order by fin.c desc,title;

--16--
select title from paper,(select paper2id from citation group by paper2id having count(*)>10) as fin where fin.paper2id=paper.paperid order by title;

--17--
select title from bar20,bar21,paper where bar20.paper2id=bar21.paper1id and  bar20.c-bar21.n>=10 and paper.paperid=bar20.paper2id order by title;

--18--
select title from paper ,(select paperid from paper except (select paper2id from citation group by paper2id)) as fun where fun.paperid=paper.paperid order by title;

--19--
select name from author,(select distinct c from sa2 where c=d) as fr where fr.c=author.authorid order by name;

--20--
select corr.name from corr,ieic where corr.name=ieic.name order by name;

--21--
select ba1.name as "journal.name" from ba1,ba2 where ba1.name=ba2.name and cast(ba1.year as int)=cast(ba2.year as int) + 1 and ba1.count>ba2.count group by ba1.name having count(ba1.count)=4 or (count(ba1.count)=3 and ba1.name not in (select name from ba3 )) order by ba1.name;

--22--
select name,mad.year from jy,(select year,(Max(se)) as num from jy group by year) as mad where mad.num=jy.se and mad.year=jy.year order by mad.year;

--CLEANUP--
drop view corr cascade;
drop view iei;
drop view ieic;
drop view tcs;
drop view bar;
drop view sa2;
drop view ba1;
drop view ba2;
drop view ba3;
drop view jy;
drop view bar1;
drop view bar2;
drop view bar3;
drop view v;
drop view v1;
drop view bar4;
drop view bar5;
drop view bar6 cascade;
drop view bar7;
drop view bar8;
drop view bar9;
drop view bar20;
drop view bar21;
drop view sa1;
drop view bar22;
drop view bar10;