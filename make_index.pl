#!/usr/bin/perl -w
# written by Chris Crowley 2009.01.24
# all wrongs reversed

## INPUT
#  input file is named the SANS book and is a semi-colon delimited file of format:
#  page;keyword1;keyword2;...

my $filename;
my $pagenum;
my $word;
my @tmp;
my @filelist;
$wordlist{"a"} = "0";
my $DEBUG=0;

if ( scalar(@ARGV) == 0 ) {

	print "NOTE: Filenames will be used to create the index referene.\nPlease enter the names of the files to create the index from, separated by spaces: ";
	$filename = <>;
	chomp $filename;
	@filelist = split(/ /,$filename);

} else {

	@filelist = @ARGV;
}

while (scalar(@filelist) ) {

  $filename = shift(@filelist);


  die "failed to open $filename" unless (open (INFILE, "$filename"));

  while (<INFILE>) {

	chomp;
	# DEBUG input
	if ( $DEBUG != 0) { print "$_\n"; };

	@tmp=split(/\;/,$_);
	# DEBUG array
	if ( $DEBUG != 0) { print "@tmp\n"; };

	$pagenum=shift(@tmp);
	# DEBUG pagenum
	if ( $DEBUG != 0) { print "$pagenum\n"; };

	while ( scalar(@tmp) ) {
		$word = lc(pop(@tmp));
		$word =~ s/^ //;
		if ( defined($wordlist{$word}) ) {
			$wordlist{$word} = "$wordlist{$word}" . ", " . "$filename.$pagenum";
		} else {
			$wordlist{$word} = "$filename.$pagenum";
		}
	}


  }

} #end while filelist


@tmp = reverse (sort (keys(%wordlist) ) );

while ( scalar(@tmp) ) {

	$word = pop(@tmp);
	
	# Currently, there is no sorting done on the list output.
	# This clearly could be improved.  In the meantime, provide the files in order.
	print "$word: $wordlist{$word}\n";
}
