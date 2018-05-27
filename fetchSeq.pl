#!/usr/bin/perl -w
# 版本:1.0
# 本脚本用于解析Genbank格式文件提取出特定的序列片段
use strict;
use warnings;
use Bio::SeqIO;

my @allFile = glob"./Seq/*.gb";

foreach my $filename (@allFile) {
  #print "Retriving ".$filename."...\n";
  my $seqIO = Bio::SeqIO->new(-file => $filename,
                            -format => "genbank"
                            );
  my $seq = $seqIO -> next_seq;

  my $tarSeq;
  my @seqName;
  foreach my $feature ($seq -> get_SeqFeatures) { #对注释进行逐级扫描, 提取出特定注释的序列
                                                  #本脚本中解析的是ORF2/编码衣壳蛋白的片段
      if ($feature -> has_tag("product")) {
        my @value = $feature->get_tag_values("product");
        if ($value[0] =~ /ORF2|capsid|^structural/) {
          $tarSeq = $feature -> seq -> seq;

        }
      }elsif($feature -> has_tag("organism")){
          @seqName = $feature->get_tag_values("organism");
      }
  }
  print $filename."\n";
  $filename =~ s/\.\/Seq\///;
  $filename =~ s/\.gb//;
  print $filename."\n";
  print ">gb\|".$filename."\_".$seqName[0]."\n";
  print $tarSeq."\n";
  open OUT, ">./fetched_Seq/$filename\.fas";
    print OUT ">gb\|".$filename."\_".$seqName[0]."\n";
    print OUT $tarSeq."\n";
  close OUT;
}
