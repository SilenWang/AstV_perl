#!/usr/bin/perl -w
#本脚本用于在genbank中查询序列条目信息并将条目信息保存下来

use strict;
use warnings;
use Bio::DB::GenBank;
use Bio::DB::Query::GenBank;

#my $query_string = 'Arabidopsis[ORGN] AND topoisomerase[TITL] and 0:3000[SLEN]';
#my $query = Bio::DB::Query::GenBank->new(-db => 'nucleotide',
                                         #-query => $query_string);

#print $query->count,"\n";

my $query = "txid39733[Organism:exp] AND complete";
my $query_obj = Bio::DB::Query::GenBank->new(-db => 'nucleotide',  -query => $query );
my $gb_obj = Bio::DB::GenBank->new();
my $stream_obj = $gb_obj->get_Stream_by_query($query_obj);

open OUT, ">./accession";#准备序列写入用文件
while (my $seq_obj = $stream_obj->next_seq) {
    # do something with the sequence object
    print OUT $seq_obj->display_id,"\n";
    print $seq_obj->display_id, "\t", $seq_obj->length, "\n"; # 打印序列id及长度信息到屏幕
}
close OUT;
