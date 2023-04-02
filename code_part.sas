%let outpath=<your path>;

proc import datafile="&outpath\ratings.csv"
	dbms=csv out=ratings;
run;

proc contents data=ratings;	
run;

proc print data=ratings(obs=10);		
	var user_id movie rating;
	format user_id COMMA15.;		
run;

data ratingmovie;				
	set ratings;					
	drop VAR1;					
	if rating=5 then comment="excellent";	
	else if rating=4 then comment="good";	
	else if rating=3 then comment="medium";	
	else if rating=2 then comment="not good";	
	else if rating=1 then comment="bad";	
run;

proc print data=ratingmovie(obs=10);
run;

%let name=toy+story;												
proc print data=ratingmovie(obs=10) label;					
	where movie like "&name%";	
	var user_id movie rating comment;
	label movie="&name series";						
run;


data userinfor;
	set ratings;
	keep user_id num_movies total_rating avg_rating ;
	by user_id;
	retain num_movies total_rating;			
	if First.user_id then num_movies=0;	
	num_movies+1;				
	if First.user_id then total_rating=0;		
	 total_rating+rating;							
	if Last.user_id;

	avg_rating=total_rating/num_movies;
	drop total_rating;

run;
proc sort data=userinfor out=userinfor_sort;	
	by descending num_movies;
run;

proc print data=userinfor_sort(obs=10);	
run;
proc means data=userinfor_sort;
run;
