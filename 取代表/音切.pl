# �B�z����

$infile = "q.TXT";			# ��J��
$outfile = "out.txt";		# ��X��

#######################################

open IN, "$infile";
@lines = <IN>;
close IN;

open OUT, ">$outfile";
my $atn = 0;	# �O�_�b <n> �аO��?
my $keep = "";	# ����b�e�@��B�z�L�����.
#my $big5='(?:(?:[\x80-\xff][\x40-\xff])|(?:[\x00-\x7f]))';
my $losebig5='(?:(?:[\x80-\xff][\x40-\xff])|(?:[\x00-\x5a])|(?:\x5c)|(?:[\x5e-\x7f]))';
#my $big5='(?:(?:\[(?:(?:[\x80-\xff][\x40-\xff])|(?:[\x00-\x5a])|(?:\x5c)|(?:[\x5e-\x7f]))+\])|(?:[\x80-\xff][\x40-\xff])|(?:[\x00-\x5a])|(?:\x5c)|(?:[\x5e-\x7f]))';
my $big5='(?:(?:\[(?:(?:[\x80-\xff][\x40-\xff])|(?:[\x00-\x5a])|(?:\x5c)|(?:[\x5e-\x7f]))+\])|(?:[\x80-\xff][\x40-\xff])|(?:[\x00-\x7f]))';

for ($i = 0; $i<=$#lines; $i++)
{
	$_ = $lines[$i];

	if($atn)
	{
		s/^(X.*?��(�@)*)//;
		$head = $1;
		$body = "";
		
		if($keep)	# �p�G���榳�W�@��B�z�L��, �N�����X��
		{
			$body = $keep;
			s/^\Q${keep}\E//;
			$keep = "";
		}
		
		if(/^(${big5}+?)(\(${big5}+?\))/ or $_ eq "\n" or $_ eq "")
		{
			while(/^(${big5}+?)(\(${big5}+?\))/)
			{
				s/^(${big5}+?)(\(${big5}+?\))//;
				$body = $body . "<n>$1<d><p,1>$2";
			}
			
			if($_ ne "" and $_ ne "\n")	# �ݬݤU�@��
			{
				if($i != $#lines)
				{
					$nextline = $lines[$i+1];
					$nextline =~ s/^(X.*?��(�@)*)//;
					$nexthead = $1;
					$body2 = $_ . $nextline;
					if($body2 =~ /^(${big5}+?)(\(${big5}+?\))/)
					{
						$fir = $1;
						$sec = $2;
						
						# �Ĥ@��]�t�A��
						if($_ =~ /(\Q${fir}\E)(\(${big5}+)/)
						{
							$body = $body . "<n>$1<d><p,1>$2";
							$nextline =~ /^(${big5}*?\))/;
							$keep = $1;
						}
						else	# �Ĥ@��S�A��
						{
							$body = $body . "<n>$_";
							$nextline =~ s/^(${big5}*?)(\(${big5}+?\))/$1<d><p,1>$2/;
							$keep = "$1<d><p,1>$2";
							$lines[$i+1] = $nexthead . $nextline;
						}
						$_ = "";
					}
					else
					{
						$atn = 0;
						$body = $body . "</n>";
					}
				}
				else
				{
					$atn = 0;
					$body = $body . "</n>";
				}
			}
			$lines[$i] = $head . $body . $_;
		}
		else
		{
		  	$lines[$i-1] =~ s/\n/<\/n>\n/;
		  	$atn = 0;
		}
	}

	if($lines[$i] =~ /����((��)|(��)|(�q))/) 
	{
		$atn = 1;
	}
}

if($atn)
{
	$lines[$#lines] =~ s/(\n)?$/<\/n>$1/;
}

for ($i = 0; $i<=$#lines; $i++)
{
	print OUT $lines[$i];
}

close OUT;
	