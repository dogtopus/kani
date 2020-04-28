open (BASE,"base0.txt") or die;
open (OUT,">0.txt");
open (IN, "1.txt");
my $gloval = 4001;
my $user = 21;
my %flag;

while ( my $line = <BASE> ){
	if ( $line =~ /;get_numalias/ ){

		while ( my $line2 = <IN> ){
			if ( $line2 =~ /\%(g[a-zA-Z_0-9]*)/ ){
				if (( $flag{$1} != 1 ) && ( $1 ne "" )){
					print OUT "numalias $1,$gloval\n";
					$gloval++;
					$flag{$1} = 1;
				}
	
			}elsif( $line2 =~ /\%([a-zA-z][a-zA-Z_0-9]*)/ ){
				if (( $flag{$1} != 1 ) && ( $1 ne "" )){
					print OUT "numalias $1,$user\n";
					$user++;
					$flag{$1} = 1;
				}
			}
		}
	}elsif ( $line =~ /;initialflag/ ){
		for ( $i = 21 ; $i <= $user ; $i++ ){
			print OUT "mov \%$i,0\n";
		}

	}else{
		print OUT $line;
	}
}
close IN;
close OUT;
close BASE;