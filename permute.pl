#!/usr/bin/perl

# License:		GPLv3 - see license file or http://www.gnu.org/licenses/gpl.html
# Program-version:	2.0, (13th August 2017)
# Description:		Permutes an incoming array and returns an array with all permutations
# Contact:		Dominik Bernhardt - domasprogrammer@gmail.com or https://github.com/DomAsProgrammer


### Modules

use strict;
use warnings;
use bignum;
use POSIX;


### Variables

my $call		= $0;
my @permutations	= ();

my @elements		= @ARGV;

if ( grep(/-{1,2}(h|help)/i, @ARGV) ) {
	usage(0);
	}
elsif ( scalar(@ARGV) <= 2 ) {
	print STDERR "Not enough arguments!\n";
	usage(1);
	}

my $seperator	= shift(@elements);
my $num_elem	= scalar(@elements);

# Some later needed variables
my @pseudo_elem		= ();
my $fact_num_elem	= factorial($num_elem);
my @column_huge		= ();


### Program
foreach my $alias ( 1..$num_elem ) {
	push(@pseudo_elem, $alias);
	}

for ( my $column = $num_elem ; scalar(@column_huge) <= $num_elem && $column >= 0 ; $column-- ) { # < ignores last column
	push(@column_huge, {	elements	=> $column,
				factorial	=> factorial($column),
				});
	}

# Only for output (and better RAM handling)
for ( my $line = 0 ; $line < $fact_num_elem ; $line++ ) {
	my $peremm		= [];
	my @helper		= ();
	my @current_pseudo_elem	= @pseudo_elem;
	for ( my $column = 0 ; $column < $num_elem ; $column++ ) {
		my $return = set_pos($line, $column_huge[$column], [ @current_pseudo_elem ]);
		$peremm->[$column] = $return;
		push(@helper, $return);
		my $helper = join("\|", @helper);
		@current_pseudo_elem = grep(!/^($helper)$/, @current_pseudo_elem);
		}
	$peremm	= [ trans_out($peremm, [ @elements ]) ];
	}

## Save in a array, too
#for ( my $line = 0 ; $line < $fact_num_elem ; $line++ ) {
#	$permutations[$line]	= [];
#	my @helper		= ();
#	my @current_pseudo_elem	= @pseudo_elem;
#	for ( my $column = 0 ; $column < $num_elem ; $column++ ) {
#		my $return = set_pos($line, $column_huge[$column], [ @current_pseudo_elem ]);
#		$permutations[$line]->[$column] = $return;
#		push(@helper, $return);
#		my $helper = join("\|", @helper);
#		@current_pseudo_elem = grep(!/^($helper)$/, @current_pseudo_elem);
#		}
#	$permutations[$line]	= [ trans_out($permutations[$line], [ @elements ]) ];
#	}


### Subfunctions
sub trans_out {
	my @code	= @{( shift )};
	my @names	= @{( shift )};

	foreach my $position ( @code ) {
		$position	= $names[$position - 1];
		}

	print join("$seperator", @code) . "\n";
	return(@code);
	}

sub factorial {
	my $number	= shift;
	my $calculation	= ( $number ) ? 1 : 0; # return a zero as zero for correct usage of array positions

	for ( my $i = 1 ; $i <= $number ; $i++ ) {
		$calculation *= $i;
		}
	return($calculation);
	}

sub set_pos {
	my $Line		= shift;
	my %size		= %{( shift )};
	my @Elements		= @{( shift )};
	$Line			%= $size{factorial};

	if ( scalar(@Elements) > 1 ) {
		return($Elements[ floor($Line / ( $size{factorial} / $size{elements} )) ]);
		}
	elsif ( scalar(@Elements) == 1 ) {
		return($Elements[0]);
		}
	else {
		print STDERR "Missing elements in array!\n";
		exit(3);
		}
	}

sub usage {
	my $level	= shift;
	my $pipe	= '';

	if ( $level ) {
		$pipe = *STDERR;
		}
	else {
		$pipe = *STDOUT;
		}

	print $pipe "Usage: $call <SEPERATOR> <OBJECT1> <OBJECTn> <OBJECT9>\n",
		"\tExample: $call \"\" a b c\n",
		"\treturns:\n",
		"\tabc\n",
		"\tacb\n",
		"\tbac\n",
		"\tbca\n",
		"\tcab\n",
		"\tcba\n";
	exit($level);
	}
