#!/usr/bin/perl -w
# drupal .htaccess deamon

use 5.10.1;
$|++;

die "Gimme a file to look at!\n" unless scalar @ARGV == 1;

# /var/www/drupal/8/.htaccess
chomp (my $file = shift @ARGV);

die "This File dosn't exist!\n" unless -e $file;

my $pid;
my $parent = $$;


FORKY: 
{ 
	defined ($pid = fork) or die "Can't Fork! $!\n";
	exit if $$ == $parent;
	print "$$\n";
}

my @code = join "", <DATA>;

while (1)
{
	
	next unless -f $file;
	$time = time;
	
	# I know this is crazy but I just don't have the time ;) You'll understand eventually!
	my $replace = qq~perl -00 -i.${time}.bak -wple 's`(?<=RewriteEngine on)`@{code}`' $file~;
	my $condition = qq`perl -0777 -wnle 'print m~\#MIKER-CAN-YOU-SEE-ME~ ? 1 : 0' ${file}`;
	system qq~$replace~ unless `${condition}`;

	sleep 30;
	
}

__END__

#MIKER-CAN-YOU-SEE-ME

# Allow Slider access
RewriteCond \%{REQUEST_URI} "/___/"
RewriteRule (.*) \$1 [L] 

# Redirect for IITS front page
RewriteCond \%{HTTP_HOST} iits.dentistry.utoronto.ca [NC]
RewriteCond \%{REQUEST_URI} ^/\$ 
Rewriterule ^(.*)\$ https://beta-www.dentistry.utoronto.ca/welcome [L,R=301]

# Redirect for CDE front page
# RewriteCond \%{HTTP_HOST} cde.dentistry.utoronto.ca [NC]
# RewriteCond \%{REQUEST_URI} ^/\$ 
# Rewriterule ^(.*)\$ https://beta-www.dentistry.utoronto.ca/welcome [L,R=301]

# Redirect for Patient page
RewriteCond \%{HTTP_HOST} patients.dentistry.utoronto.ca [NC]
RewriteCond \%{REQUEST_URI} ^/\$ 
Rewriterule ^(.*)\$ https://beta-www.dentistry.utoronto.ca/welcome [L,R=301]

# Redirect for Forms  page
RewriteCond \%{HTTP_HOST} forms.dentistry.utoronto.ca [NC]
RewriteCond \%{REQUEST_URI} ^/\$ 
Rewriterule ^(.*)\$ https://beta-www.dentistry.utoronto.ca/welcome [L,R=301]


