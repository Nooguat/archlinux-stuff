#!/usr/bin/perl -w

use DBI;
use Encode;

%TYPES = (
    56 => "int",
    167 => "varchar",
    104 => "bit",
    36 => "uniqueidentifier",
    231 => "nvarchar",
    61 => "datetime",
    60 => "money",
    34 => "image",
    99 => "ntext",
    127 => "bigint"
);

sub get_tables
{
    my $db = shift;
    my $sql = "SELECT name, id, xtype FROM sysobjects";
    my $q = $db->prepare($sql);
    $q->execute();

    my $r;
    my $ret = [];

    while(@$r = $q->fetchrow_array())
    {
	if($r->[2] eq "U ")
	{
	    push @$ret, $r->[0];
	}
    }
    return $ret;
}

sub get_table_columns
{
    my $db = shift;
    my $table = shift;
    my $sql = "select name, xtype, length from syscolumns where id in (select id from sysobjects where name = '$table')";
    my $q = $db->prepare($sql);
    $q->execute();

    my $r;
    my $ret = [];
    my $c = 0;

    while(@$r = $q->fetchrow_array())
    {
	$ret->[$c] = {};
        $ret->[$c]{name} = $r->[0];
        $ret->[$c]{type} = $r->[1];
        $ret->[$c]{len} = $r->[2];
	$c++;
    }
    return $ret;
}

#
# MAIN
#

#$db = DBI->connect('dbi:Sybase:server=sergej;database=iStatServerDB',
#		   'iStatDBUser',
#		   'mjnGfhjkm{eqGjl,thtim@))^');

$db = DBI->connect('dbi:Sybase:server=sergej;database=iWorldServerDB',
		   'iWorldDBPublicUser',
		   'VsRhextDct[@))%1');

$tables = get_tables($db);

foreach $i (@$tables)
{
    $t = get_table_columns($db, $i);
    print "$i\n";
    foreach $j (@$t)
    {
	print "    ".$j->{name}."(".$TYPES{$j->{type}}.":".$j->{len}.")\n"
    }
}

$db->disconnect();
