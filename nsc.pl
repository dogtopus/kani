;#遥かに仰ぎ、麗しの
;#コンバータ for ONScripter  20080405a

opendir (DIR,"./rio_out") or die;
@file0 = readdir(DIR);
closedir(DIR);
@file = grep( /txt/i, @file0);

$numbase = 36;
%trans;

open (OUT,">1.txt");
;#open (DEB,">debug.txt");
foreach my $file (@file){

	my $fn = $file;
	$fn =~ s/.wsc.txt//i;
	local $efmsk;
	local $name = 0;
	local @moveon;
	local $movetime;
	local $mn = 0;
	local @mnum;
	local @endleft;
	local @endtop;
	local @top;
	local @left;
	local $bgchk = 0;
	local $bgfile;
	local $voice;
	local $voiceon;
	open (IN, "./rio_out/$file") or die;
	binmode IN;
	binmode OUT;
	if ( $fn ne "MAINMENU" ){
		print OUT "\n\*L_$fn\n";
		print DEB "\n\*L_$fn\n";
		#print OUT "setwin\n";
		$/ = "\x0D\x0A";
		while ( my $line = <IN> ){
			&convert($line);
		}
		close IN;
	}
}

close OUT;
exit;

sub convert{
	my $line = $_[0];
	$line =~ s/%00%86%e6//gi;
	$line =~ s/\x0D\x0A//i;

	if (( $voiceon == 1 ) && ( $line !~ /^%00%42/ )){
		print OUT "dwavestop 0:dwave 0,\"voice/$voice.ogg\"\n";
		$voiceon = 0;
	}

	if ( $line =~ /^%00%21%..%([0-9A-Fa-f][0-9A-Fa-f])%([0-9A-Fa-f][0-9A-Fa-f])%0a(.*?)%00/ ){
		my $dec = $3;
		my $fade = hex("$2$1");
		$dec =~ s/%([0-9A-Fa-f][0-9A-Fa-f])/pack("H2", $1)/eg;
		;#print OUT "bgmfadein $fade:";
		print OUT "bgm \"bgm/$dec.ogg\"\n";

	}elsif ( $line =~ /^%00%22%..%([0-9A-Fa-f][0-9A-Fa-f])%([0-9A-Fa-f][0-9A-Fa-f])%00/ ){
		my $fade = hex("$2$1");
		;#print OUT "bgmfadeout $fade:";
		print OUT "stop\n";

	}elsif ( $line =~ /^%00%23(?:%[0-9A-Fa-f][0-9A-Fa-f]){6}%00(.*?)%00/ ){
		my $dec = $1;
		$dec =~ s/%([0-9A-Fa-f][0-9A-Fa-f])/pack("H2", $1)/eg;
		$voice = $dec;
		$voiceon = 1;
		;#print OUT "dwavestop 0:dwave 0,\"voice/$dec.ogg\"\n";

	}elsif ( $line =~ /^%00%25%([0-9A-Fa-f][0-9A-Fa-f])(?:%[0-9A-Fa-f][0-9A-Fa-f]){7}(?:%[0-9a-fA-F][0-9a-fA-F])(.*?)%00/ ){
		my $chn = hex($1) + 1;
		my $dec = $2;
		$dec =~ s/%([0-9A-Fa-f][0-9A-Fa-f])/pack("H2", $1)/eg;
		print OUT "dwave $chn,\"se/$dec\"\n";

	}elsif ( $line =~ /^%00%26%([0-9A-Fa-f][0-9A-Fa-f])%00/ ){
		my $chn = hex($1) + 1;
		if ( $chn == 256 ){
			;#print OUT "dwavestop 0:dwavestop 1:dwavestop 2:dwavestop 3:dwavestop 4\n";
			print OUT "dwsa\n"
		}else{
			print OUT "dwavestop $chn\n";
		}

	}elsif ( $line=~ /^%00%29%[0-9A-Fa-f][0-9A-Fa-f]%([0-9A-Fa-f][0-9A-Fa-f])%([0-9A-Fa-f][0-9A-Fa-f])%00/ ){
		my $wt = hex("$2$1");
		print OUT "wait2 $wt\n";

	}elsif ( $line=~ /^%00%30%[0-9A-Fa-f][0-9A-Fa-f]%([0-9A-Fa-f][0-9A-Fa-f])%([0-9A-Fa-f][0-9A-Fa-f])%00/ ){
		my $wt = hex("$2$1");
		print OUT "wait2 $wt\n";

	}elsif ( $line =~ /^%00%41(?:%[0-9A-Fa-f][0-9A-Fa-f]){2}%00(.*?)%00/ ){
		my $dec = $1;
		$dec =~ s/%([0-9A-Fa-f][0-9A-Fa-f])/pack("H2", $1)/eg;
		$dec =~ s/\\n/\n/gi;
		$dec =~ s/\{(.*?):(.*?)\}/\($1\/$2\)/gi;
		print OUT "[1||]$dec\\\n";

	}elsif ( $line =~ /^%00%42(?:%[0-9A-Fa-f][0-9A-Fa-f]){2}%00%00(.*?)%00(.*?)%00/ ){
		my $name = $1;
		my $dec = $2;
		$dec =~ s/(?<!%8[0-9a-fA-F])%21/%81%49/g;
		$dec =~ s/(?<!%8[0-9a-fA-F])%3f/%81%48/g;
		$name =~ s/%([0-9A-Fa-f][0-9A-Fa-f])/pack("H2", $1)/eg;
		$dec =~ s/%([0-9A-Fa-f][0-9A-Fa-f])/pack("H2", $1)/eg;
		$dec =~ s/\{(.*?):(.*?)\}/\($1\/$2\)/gi;
		$dec =~ s/\\n/\n/gi;
		my $nalocate = 220 - (length($name))*6;
		;#print OUT "erasetextwindow 0\n";
		;#print OUT "lsps 0,\":s/24,24,2;#FFFFFF$name\",$nalocate,431\n";
		;#print OUT "lsps 1,\"image/nmbase.png\",50,424\n";
		;#print OUT "print 1\n";
		;#print OUT "name \"$name\",$nalocate\n";
		print OUT "[1|$name|$voice]$dec\\\n";
		;#print OUT "csp2 0:csp2 1:print 1:erasetextwindow 1:dwavestop 0\n";
		print OUT "nend\n";
		$voiceon = 0;
		$voice = "";
	
	}elsif ( $line =~ /^%00%46%([0-9A-Fa-f][0-9A-Fa-f])%([0-9A-Fa-f][0-9A-Fa-f])%([0-9A-Fa-f][0-9A-Fa-f])%([0-9A-Fa-f][0-9A-Fa-f])(?:%00){5}(.*?)%00/ ){
		my $dec = $1;
		my $num = $numbase + 1 ;
		if ( substr($2,0,1) eq "f" ){
			$left[$num] = - ( hex($1) - (( 256 - hex($2)) * 256) );
		}else{
			$left[$num] = - hex("$2$1");
		}
		if ( substr($4,0,1) eq "f" ){
			$top[$num] = - ( hex($3) - (( 256 - hex($4)) * 256) );
		}else{
			$top[$num] = - hex("$4$3");
		}
		my $dec = $5;
		$dec =~ s/%([0-9A-Fa-f][0-9A-Fa-f])/pack("H2", $1)/eg;
		#print OUT "lsps $num,\"image/$dec.png\",$left[$num],$top[$num]\n";

		if ( $line =~ /%00%68%([0-9A-Fa-f][0-9A-Fa-f])%([0-9A-Fa-f][0-9A-Fa-f])%([0-9A-Fa-f][0-9A-Fa-f])%([0-9A-Fa-f][0-9A-Fa-f])%([0-9A-Fa-f][0-9A-Fa-f])%([0-9A-Fa-f][0-9A-Fa-f])/ ){
			my $rate = hex("$2$1");
			my $centx;
			my $centy;
			if ( substr($4,0,1) eq "f" ){
				$centx = hex($3) - (( 256 - hex($4)) * 256);
			}else{
				$centx = hex("$4$3");
			}
			if ( substr($6,0,1) eq "f" ){
				$centy = hex($5) - (( 256 - hex($6)) * 256);
			}else{
				$centy = hex("$6$5");
			}

			if ( $rate == 100 && $centx == 400 && $centy == 300 ){
				if (( $bgchk == 0 ) || ( $bgfile ne $dec )){
					print OUT "lsps $num,\":c;image/$dec.png\",$left[$num],$top[$num]\n";
				}
				$bgfile = $dec;
				$bgchk = 1;
			}else{
				print OUT "lspsr $num,\":c;image/$dec.png\",$centx,$centy,$rate\n";
				$bgchk = 0;

			}
		}else{
			if (( $bgchk == 0 ) || ( $bgfile ne $dec )){
				print OUT "lsps $num,\":c;image/$dec.png\",$left[$num],$top[$num]\n";
			}
			$bgfile = $dec;
			$bgchk = 1;
			print OUT "lsps $num,\":c;image/$dec.png\",$left[$num],$top[$num]\n";
		}
			

	}elsif ( $line =~ /^%00%48%([0-9A-Fa-f][0-9A-Fa-f])%([0-9A-Fa-f][0-9A-Fa-f])%([0-9A-Fa-f][0-9A-Fa-f])%([0-9A-Fa-f][0-9A-Fa-f])%([0-9A-Fa-f][0-9A-Fa-f])(?:%00){5}%[0-9A-Fa-f][0-9A-Fa-f](.*?)%00/ ){
		my $num = $numbase - hex($1);
		if ( substr($3,0,1) eq "f" ){
			$left[$num] = hex($2) - (( 256 - hex($3)) * 256);
		}else{
			$left[$num] = hex("$3$2");
		}
		if ( substr($5,0,1) eq "f" ){
			$top[$num] = hex($4) - (( 256 - hex($5)) * 256);
		}else{
			$top[$num] = hex("$5$4");
		}
		my $dec = $6;
		$dec =~ s/%([0-9A-Fa-f][0-9A-Fa-f])/pack("H2", $1)/eg;
		print OUT "lsps $num,\"image/$dec.png\",$left[$num],$top[$num]\n"; 

	}elsif ( $line =~ /^%00%49%([0-9A-Fa-f][0-9A-Fa-f])%00/ ){
		my $num = $numbase - hex($1);
		if ( $num == $numbase ){
			print OUT "cspchar\n";
		}

	}elsif ( $line =~ /^%00%4a%([0-9A-Fa-f][0-9A-Fa-f])%([0-9A-Fa-f][0-9A-Fa-f])%([0-9A-Fa-f][0-9A-Fa-f])/ ){
		my $time = hex("$3$2");
		if ( $time == 0 ) {
			print OUT "print 1\n";
		}elsif ( $1 eq "2a") {
			print OUT "print 18,$time,\":c;image/$efmsk.png\"\n";
		}elsif ( $1 eq "1d" ){
			print OUT "print 13,$time\n";
		}elsif ( $1 eq "19" ){
			print OUT "print 10,$time\n";
		}else{
			print OUT "print 10,$time;$1\n";
			$trans{$1} = 1;
		}
	
	}elsif ( $line =~ /^%00%4b%([0-A-Fa-f][0-9A-Fa-f])%([0-A-Fa-f][0-9A-Fa-f])%([0-A-Fa-f][0-9A-Fa-f])%([0-A-Fa-f][0-9A-Fa-f])%([0-A-Fa-f][0-9A-Fa-f])%([0-A-Fa-f][0-9A-Fa-f])%([0-A-Fa-f][0-9A-Fa-f])/ ){
		if ( substr($1,0,1) eq "6"){
		}else{
			$num = $numbase + 1 - hex($1);
			if ( $moveon[$num] == 1 ){
				$mnum[$mn] = $num;
				if ( $num != $numbase + 1){
					if ( substr($3,0,1) eq "f" ){
						$endleft[$mn] = $left[$num] + ( hex($2) - (( 256 - hex($3)) * 256) );
					}else{
						$endleft[$mn] = $left[$num] + hex("$3$2");
					}
					if ( substr($5,0,1) eq "f" ){
						$endtop[$mn] = $top[$num] + ( hex($4) - (( 256 - hex($5)) * 256));
					}else{
						$endtop[$mn] = $top[$num] + hex("$5$4");
					}
				}else{
					if ( substr($3,0,1) eq "f" ){
						$endleft[$mn] = $left[$num] - ( hex($2) - (( 256 - hex($3)) * 256) );
					}else{
						$endleft[$mn] = $left[$num] - hex("$3$2");
					}
					if ( substr($5,0,1) eq "f" ){
						$endtop[$mn] = $top[$num] - ( hex($4) - (( 256 - hex($5)) * 256));
					}else{
						$endtop[$mn] = $top[$num] - hex("$5$4");
					}
				}
				
				$movetime = hex("$7$6");
				$mn++;
				$moveon[$num] = 0;
			}else{
				$moveon[$num] = 1;
			}

		}
	}elsif ( $line =~ /^%00%4c%/ ){
		&move();
		$mn = 0;

	}elsif ( $line =~ /^%00%4d%/ ){
		print OUT "quake 3,100\n";
	
	}elsif ( $line =~ /^%00%54(.*?)%00/ ){
		$efmsk = $1;
		$efmsk =~ s/%([0-9A-Fa-f][0-9A-Fa-f])/pack("H2", $1)/eg;

	}elsif ( $line =~ /^%00%55%00$/ ){

	}elsif ( $line =~ /^%00%71(.*?)%00/ ){
		my $face = $1;
		$face =~ s/%([0-9A-Fa-f][0-9A-Fa-f])/pack("H2", $1)/eg;
		print OUT "face \"$face\"\n";

	}elsif ( $line =~ /^%00%73%([0-9A-Fa-f][0-9A-Fa-f])%([0-9A-Fa-f][0-9A-Fa-f])%([0-9A-Fa-f][0-9A-Fa-f])%([0-9A-Fa-f][0-9A-Fa-f])(?:%00){5}(.*?)%00/ ){
		if ( substr($2,0,1) eq "f" ){
			$lefts = hex($1) - (( 256 - hex($2)) * 256);
		}else{
			$lefts = hex("$2$1");
		}
		if ( substr($4,0,1) eq "f" ){
			$tops = hex($3) - (( 256 - hex($4)) * 256);
		}else{
			$tops = hex("$4$3");
		}
		my $dec = $5;
		$dec =~ s/%([0-9A-Fa-f][0-9A-Fa-f])/pack("H2", $1)/eg;
		printf OUT "lsps %d,\"image/$dec.png\",$lefts,$tops\n",$numbase - 4 ; 

	}elsif ( $line =~ /^%00%74%/ ){
		#printf OUT "csp2 %d\n",$numbase - 4 ;

	}elsif ( $line =~ /^%00%01%06%([0-9A-Fa-f][0-9A-Fa-f])%([0-9A-Fa-f][0-9A-Fa-f])%([0-9A-Fa-f][0-9A-Fa-f])%00%([0-9A-Fa-f][0-9A-Fa-f])/ ){
		my $val = int($3);
		if ( $2 eq "00"){
			$flag = "flag_$1";
		}else{
			$flag = "gflag_$1";
		}
		if ( $4 eq "08"){
			print OUT "add \%$flag,1\n";
		}elsif ( $4 eq "0a" ){
			print OUT "if \%$flag < $val ";
		}
	}elsif ( $line =~ /^%00%01%01%([0-9A-Fa-f][0-9A-Fa-f])%([0-9A-Fa-f][0-9A-Fa-f])%([0-9A-Fa-f][0-9A-Fa-f])%00%([0-9A-Fa-f][0-9A-Fa-f])/ ){
		my $val = int($3);
		if ( $2 eq "00"){
			$flag = "flag_$1";
		}else{
			$flag = "gflag_$1";
		}
		if ( $4 eq "08"){
			print OUT "add \%$flag,1\n";
		}elsif ( $4 eq "0a" ){
			print OUT "if \%$flag >= $val ";
		}
	
	}elsif ( $line =~ /^%00%01%11%([0-9A-Fa-f][0-9A-Fa-f])%([0-9A-Fa-f][0-9A-Fa-f])%([0-9A-Fa-f][0-9A-Fa-f])%00%([0-9A-Fa-f][0-9A-Fa-f])/ ){
		my $val = "flag_$3";
		if ( $2 eq "00"){
			$flag = "flag_$1";
		}else{
			$flag = "gflag_$1";
		}
		if ( $4 eq "08"){
			print OUT "add \%$flag,1\n";
		}elsif ( $4 eq "0a" ){
			print OUT "if \%$flag >= \%$val ";
		}
	
	}elsif ( $line =~ /^%00%02%02%00(?:%[0-9A-Fa-f][0-9A-Fa-f]){2}(.*?)%00(?:%[0-9A-Fa-f][0-9A-Fa-f]){3}%07(.*?)%00(?:%[0-9A-Fa-f][0-9A-Fa-f]){2}(.*?)%00(?:%[0-9A-Fa-f][0-9A-Fa-f]){3}%07(.*?)%00/ ){
		my $sel1 = $1;
		my $goto1 = $2;
		my $sel2 = $3;
		my $goto2 = $4;
		$sel1 =~ s/%([0-9A-Fa-f][0-9A-Fa-f])/pack("H2", $1)/eg;
		$sel2 =~ s/%([0-9A-Fa-f][0-9A-Fa-f])/pack("H2", $1)/eg;
		$goto1 =~ s/%([0-9A-Fa-f][0-9A-Fa-f])/pack("H2", $1)/eg;
		$goto2 =~ s/%([0-9A-Fa-f][0-9A-Fa-f])/pack("H2", $1)/eg;
		print OUT "cselect2 \"$sel1\",\"\*L_$goto1\",\"$sel2\",\"\*L_$goto2\"\n";
		print OUT "goto \$1\n";

	}elsif ( $line =~ /^%00%07(.*?)%00/ ){
		my $dec = $1;
		$dec =~ s/%([0-9A-Fa-f][0-9A-Fa-f])/pack("H2", $1)/eg;
		if ( $dec ne "EVRET" ){
			print OUT "goto \*L_$dec\n";
		}

	}elsif ( $line =~ /^%00%03%01%d3%02%00(?:%00)%00%00/ ){
		print OUT "textoff1\n";
	}

	else{
		#print OUT ";$line\n";
	}
}


sub move{
	print OUT "isskip %0:if %0=1 jumpf\n";
	print OUT "saveoff\nresettimer\n";
	print OUT "for %1=1 to 999999\n";
	print OUT "gettimer %2\n";
	print OUT "if %2>=$movetime break\n";
	for ( my $i = 0 ; $i < $mn ; $i++ ){
		my $num = $mnum[$i];
		print OUT "mov \?1\[$i\],$left[$num]+($endleft[$i]-($left[$num]))*%2/$movetime\n";
		print OUT "mov \?2\[$i\],$top[$num]+($endtop[$i]-($top[$num]))*%2/$movetime\n";
		print OUT "amsps $num,\?1\[$i\],\?2\[$i\],255\n";
	}
	print OUT "print 1\n";
	print OUT "next\n";
	print OUT "~\n";
	for ( my $i = 0 ; $i < $mn ; $i++ ){
		my $num = $mnum[$i];
		print OUT "amsps $num,$endleft[$i],$endtop[$i],255\n";
		$left[$num] = $endleft[$i];
		$top[$num] = $endtop[$i];
	}
	print OUT "print 1\nsaveon\n";saveon

}

