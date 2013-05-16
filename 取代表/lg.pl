##################################################################################
# �N <lg...><l>�u  �令  <lg ... rend="margin-left:1em;text-indent:-1em"><l>�u 
# �N <lg...><l>�u�y  �令  <lg ... rend="margin-left:2em;text-indent:-2em"><l>�u�y 
##################################################################################

$in = "T08n0239.xml";		# ��J�ɦW, �Y�O�妸�ɪ��Ѽ�, �i�� $in = shift; �Y�i
$out = "out.xml";			# ��X�ɦW, �Y�O�妸�ɪ��Ѽ�, �i�� $out = shift; �Y�i

open IN, $in;
open OUT, ">$out";

while(<IN>)
{
	if(/(<lg\s*.*?>)(<l.*?>)?�u(.?.?)/)
	{
		$lg = $1;
		$l = $2;
		$second = $3;
		
		$indent = "1em";
		if($second eq "�y")
		{
			$indent = "2em";
		}
		
		if($lg =~ /rend/)	# �� rend �F, �[�W xxx , ���� parse ���L�Ф�ʳB�z
		{
			$lg =~ s/<lg /<lg todo="�Ф�ʧ�rend" /;
		}
		else
		{
			$lg =~ s/>/ rend="margin-left:${indent};text-indent:-${indent}">/;
		}

		s/(<lg\s*.*?>)(<l.*?>)?(�u.?.?)/$lg$2$3/;
	}
	print OUT;
}
close IN;
close OUT;