#!/usr/bin/perl -w
# 版本:1.0
# 本脚本可根据确定的NCBI登录号(accession number)获取genbank格式的序列
# 为了防止IP被Ban, 提交序列号时没有使用循环
use strict;
use warnings;
use Bio::DB::GenBank;
use Bio::DB::Query::GenBank;
use Bio::SeqIO;
use Bio::Seq::RichSeq;
my @acc;
open IN, "./accession"; #读取存放有序列登录号的文件
  while (<IN>) {
    chomp;
    push @acc, $_;
  }
close IN;

my $gb = Bio::DB::GenBank->new();#NCBI数据库对象
my $seqio = $gb -> get_Stream_by_acc([@acc]);  #提交所有的序列acc到服务器, 批量获取序列必须使用get_Stream_by_acc([])
print "Search Done! Saving seq.....\n"; #本意用于判别程序运行情况, 实际似乎并没有用

while (my $seq = $seqio -> next_seq) {
  print $seq -> accession_number."\n"; #打印成功获取的序列号, 未来可加上完成情况比对部分
  my $outfile = "./AstV\_DB".$seq -> accession_number."\.gb"; #设定返回序列名称(使用acc), 分别保存
  my $seq_out = Bio::SeqIO->new( -file   => ">$outfile",
                                 -format => "genbank",#指定存储格式
                               );
  $seq_out->write_seq($seq); #SeqIO的方法中本身带有句柄功能, 所以程序中并未手写句柄段
}
