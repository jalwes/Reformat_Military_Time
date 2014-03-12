#!c:/perl/bin/perl.exe -w
#written by Jon Alwes
#December 18th, 2013

#This program will reformat the data as a two-digit month and day and also convert the time to military time. 

#Get input file name
print "Enter the name of the file (and path if not in same directory) for reformatting: \n";
$file = <STDIN>;
chomp $file;

#Create output file name with "_reformatted" appended, based on input filename
my @output = split (/\.+/, $file, 3);
my $outputFile = $output[0]."_reformatted.".$output[1];

open INPUTFILE, $file or die "Couldn't open $file: $!";
open OUTPUTFILE, ">$outputFile" or die "Couldn't open $outputFile: $!";

while (<INPUTFILE>){
	my $line = $_;
	
	#If the line starts with a date, send it to the subroutine "processLine" for processing. Otherwise, just print it as is. 
	if (/^\d+\/\d+\/\d{4}/){
		processLine($line);
	} else {
		print OUTPUTFILE "$line";
	}
}

close INPUTFILE;
close OUTPUTFILE;

sub processLine {
	my $line = shift;
	
	#Split line
		my ($date, $clock, $ampm, $data) = split (/\s+/, $line, 4);
	
	  ##########################################################################
	  #####   Check and convert date to two digits for month and day ##########
	  ##########################################################################
	  
		#Split date into month, day, year
		my ($month, $day, $year) = split (/\//, $date, 3);
		
		#If month is only one digit, prepend a '0'
		if (length($month) == 1) {
			$month = "0".$month;
		}
		
		#If day is only one digit, prepend a '0'
		if (length($day) == 1) {
			$day = "0".$day;
		}
		
		$date = $month."/".$day."/".$year;
		
		############################################
		######   Convert time to military    #######
		############################################
		
		#Split time into hours and minutes
		my ($hour, $minute) = split (/:/, $clock, 2);
		
		#If the time is a.m. - If 12, convert to 00. If before 10am, convert to two-digits
		if ($ampm eq "AM") {
			if ($hour == 12) {
				$hour = '00';
			} elsif (length($hour) == 1) {
				$hour = "0".$hour;
			}
		} else { #If the time is PM - If hour = 12, no change is needed, otherwise add 12. 
			if ($hour != 12) {
				$hour = $hour + 12;
			}
		}
		
		$clock = $hour.":".$minute;
		
		
		############################################
		########  print to output file #############
		############################################
		print OUTPUTFILE "$date $clock	$data";
}