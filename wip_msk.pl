use Image::Magick;
use File::Copy;
mkdir image;

opendir (DIR,"./mask") or die;
@file1 = readdir(DIR);
@file = grep(/png/,@file1);
closedir(DIR);
foreach $file(@file){
	unless ( -e "./wip/$file" ){
		copy ( "./mask/$file","./image/$file");
		next;
	}
	$image = Image::Magick->new;
	$rc8 = $file;
	$rtc = $rc8;
	$x = $image->Read("./wip/$file","./mask/$file");
	$p = $image->Append(stack=>false);
	$x = $p->Write("./image/$file");
	undef $image;
}

opendir (DIR,"./wip") or die;
@file1 = readdir(DIR);
@file = grep(/png/,@file1);
closedir(DIR);
foreach $file(@file){
	unless ( -e "./mask/$file" ){
		copy ( "./wip/$file","./image/$file");
	}
}
