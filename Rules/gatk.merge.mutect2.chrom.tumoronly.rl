if config['project']['annotation'] == "hg19":
  rule gatk_merge_mutect2_chrom:
    input: vcf1=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_1.vcf"),
           vcf2=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_2.vcf"),
           vcf3=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_3.vcf"),
           vcf4=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_4.vcf"),
           vcf5=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_5.vcf"),
           vcf6=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_6.vcf"),
           vcf7=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_7.vcf"),
           vcf8=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_8.vcf"),
           vcf9=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_9.vcf"),     
           vcf10=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_10.vcf"),
           vcf11=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_11.vcf"),
           vcf12=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_12.vcf"),
           vcf13=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_13.vcf"),
           vcf14=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_14.vcf"),
           vcf15=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_15.vcf"),
           vcf16=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_16.vcf"),
           vcf17=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_17.vcf"),
           vcf18=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_18.vcf"),
           vcf19=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_19.vcf"),
           vcf20=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_20.vcf"),
           vcf21=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_21.vcf"),
           vcf22=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_22.vcf"),
           vcfX=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_X.vcf"),
           vcfY=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_Y.vcf"),
           targets=config['project']['workpath']+"/exome_targets.bed"
    output: vcf=config['project']['workpath']+"/mutect2_out/{x}_mutect2.vcf",
            snps=config['project']['workpath']+"/mutect2_out/{x}.SNPs.vcf",
            indels=config['project']['workpath']+"/mutect2_out/{x}.INDELs.vcf",
            flagsnps=config['project']['workpath']+"/mutect2_out/{x}.flaggedSNPs.vcf",
            flagindels=config['project']['workpath']+"/mutect2_out/{x}.flaggedINDELs.vcf",
            flagged=config['project']['workpath']+"/mutect2_out/{x}.flagged.vcf",
            filtered=config['project']['workpath']+"/mutect2_out/{x}.FINALmutect2.vcf",
            snpeffout=config['project']['workpath']+"/mutect2_out/{x}.snpeff.out",
            csvstats=config['project']['workpath']+"/mutect2_out/{x}.mutect2.stats.csv",
            htmlstats=config['project']['workpath']+"/mutect2_out/{x}.mutect2.stats.html",
    params: tumorsample=lambda wildcards: config['project']['units'][wildcards.x],dir=config['project']['workpath'],gatk=config['bin'][pfamily]['GATK'],genome=config['references'][pfamily]['GENOME'],targets=config['references'][pfamily]['REFFLAT'],snpeff=config['bin'][pfamily]['SNPEFF'],snpeffgenome=config['references'][pfamily]['SNPEFF_GENOME'],effconfig=config['references'][pfamily]['SNPEFF_CONFIG'],rname="pl:merge.mutect2"
    shell: "module load GATK/3.8-0; GATK -m 64G CombineVariants -R {params.genome} --filteredrecordsmergetype KEEP_UNCONDITIONAL --assumeIdenticalSamples -o {output.vcf} --variant {input.vcf1} --variant {input.vcf2} --variant {input.vcf3} --variant {input.vcf4} --variant {input.vcf5} --variant {input.vcf6} --variant {input.vcf7} --variant {input.vcf8} --variant {input.vcf9} --variant {input.vcf10} --variant {input.vcf11} --variant {input.vcf12} --variant {input.vcf13} --variant {input.vcf14} --variant {input.vcf15} --variant {input.vcf16} --variant {input.vcf17} --variant {input.vcf18} --variant {input.vcf19} --variant {input.vcf20} --variant {input.vcf21} --variant {input.vcf22} --variant {input.vcfX} --variant {input.vcfY}; GATK -m 120G SelectVariants -R {params.genome} --variant {output.vcf} -selectType SNP --excludeFiltered -o {output.snps}; GATK -m 120G SelectVariants -R {params.genome} --variant {output.vcf} -selectType INDEL --excludeFiltered -o {output.indels}; GATK -m 48G VariantFiltration -R {params.genome} --variant {output.snps} --filterExpression \"FS > 60.0 || SOR > 3.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0\" --filterName \"my_snp_filter\" -o {output.flagsnps}; GATK -m 48G VariantFiltration -R {params.genome} --variant {output.indels} --filterExpression \"FS > 200.0 || SOR > 10.0 || ReadPosRankSum < -20.0\" --filterName \"my_indel_filter\" -o {output.flagindels}; GATK -m 48G CombineVariants -R {params.genome} --variant {output.flagsnps} --variant {output.flagindels} -o {output.flagged} --assumeIdenticalSamples --filteredrecordsmergetype KEEP_UNCONDITIONAL --genotypemergeoption UNSORTED; GATK -m 48G SelectVariants -R {params.genome} --variant {output.flagged} --excludeFiltered -o {output.filtered}; module load snpEff/4.3t; java -Xmx12g -jar $SNPEFF_JAR -v {params.snpeffgenome} -c {params.effconfig} -interval {input.targets} -cancer -canon -csvStats {output.csvstats} -stats {output.htmlstats} {output.filtered} > {output.snpeffout}; sed -ie 's/TUMOR/{params.tumorsample}/g' {output.filtered}"

elif config['project']['annotation'] == "hg38":
  rule gatk_merge_mutect2_chrom:
    input: vcf1=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_1.vcf"),
           vcf2=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_2.vcf"),
           vcf3=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_3.vcf"),
           vcf4=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_4.vcf"),
           vcf5=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_5.vcf"),
           vcf6=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_6.vcf"),
           vcf7=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_7.vcf"),
           vcf8=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_8.vcf"),
           vcf9=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_9.vcf"),     
           vcf10=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_10.vcf"),
           vcf11=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_11.vcf"),
           vcf12=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_12.vcf"),
           vcf13=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_13.vcf"),
           vcf14=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_14.vcf"),
           vcf15=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_15.vcf"),
           vcf16=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_16.vcf"),
           vcf17=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_17.vcf"),
           vcf18=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_18.vcf"),
           vcf19=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_19.vcf"),
           vcf20=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_20.vcf"),
           vcf21=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_21.vcf"),
           vcf22=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_22.vcf"),
           vcfX=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_X.vcf"),
           vcfY=ancient(config['project']['workpath']+"/mutect2_out/chrom_files/{x}_Y.vcf"),
           targets=config['project']['workpath']+"/exome_targets.bed"
    output: vcf=config['project']['workpath']+"/mutect2_out/{x}_mutect2.vcf",
            snps=config['project']['workpath']+"/mutect2_out/{x}.SNPs.vcf",
            indels=config['project']['workpath']+"/mutect2_out/{x}.INDELs.vcf",
            flagsnps=config['project']['workpath']+"/mutect2_out/{x}.flaggedSNPs.vcf",
            flagindels=config['project']['workpath']+"/mutect2_out/{x}.flaggedINDELs.vcf",
            flagged=config['project']['workpath']+"/mutect2_out/{x}.flagged.vcf",
            filtered=config['project']['workpath']+"/mutect2_out/{x}.FINALmutect2.vcf",
            snpeffout=config['project']['workpath']+"/mutect2_out/{x}.snpeff.out",
            csvstats=config['project']['workpath']+"/mutect2_out/{x}.mutect2.stats.csv",
            htmlstats=config['project']['workpath']+"/mutect2_out/{x}.mutect2.stats.html",
    params: tumorsample=lambda wildcards: config['project']['units'][wildcards.x],dir=config['project']['workpath'],gatk=config['bin'][pfamily]['GATK'],genome=config['references'][pfamily]['GENOME'],targets=config['references'][pfamily]['REFFLAT'],snpeff=config['bin'][pfamily]['SNPEFF'],snpeffgenome=config['references'][pfamily]['SNPEFF_GENOME'],effconfig=config['references'][pfamily]['SNPEFF_CONFIG'],rname="pl:merge.mutect2"
    shell: "module load GATK/3.8-0; GATK -m 64G CombineVariants -R {params.genome} --filteredrecordsmergetype KEEP_UNCONDITIONAL --assumeIdenticalSamples -o {output.vcf} --variant {input.vcf1} --variant {input.vcf2} --variant {input.vcf3} --variant {input.vcf4} --variant {input.vcf5} --variant {input.vcf6} --variant {input.vcf7} --variant {input.vcf8} --variant {input.vcf9} --variant {input.vcf10} --variant {input.vcf11} --variant {input.vcf12} --variant {input.vcf13} --variant {input.vcf14} --variant {input.vcf15} --variant {input.vcf16} --variant {input.vcf17} --variant {input.vcf18} --variant {input.vcf19} --variant {input.vcf20} --variant {input.vcf21} --variant {input.vcf22} --variant {input.vcfX} --variant {input.vcfY}; GATK -m 120G SelectVariants -R {params.genome} --variant {output.vcf} -selectType SNP --excludeFiltered -o {output.snps}; GATK -m 120G SelectVariants -R {params.genome} --variant {output.vcf} -selectType INDEL --excludeFiltered -o {output.indels}; GATK -m 48G VariantFiltration -R {params.genome} --variant {output.snps} --filterExpression \"FS > 60.0 || SOR > 3.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0\" --filterName \"my_snp_filter\" -o {output.flagsnps}; GATK -m 48G VariantFiltration -R {params.genome} --variant {output.indels} --filterExpression \"FS > 200.0 || SOR > 10.0 || ReadPosRankSum < -20.0\" --filterName \"my_indel_filter\" -o {output.flagindels}; GATK -m 48G CombineVariants -R {params.genome} --variant {output.flagsnps} --variant {output.flagindels} -o {output.flagged} --assumeIdenticalSamples --filteredrecordsmergetype KEEP_UNCONDITIONAL --genotypemergeoption UNSORTED; GATK -m 48G SelectVariants -R {params.genome} --variant {output.flagged} --excludeFiltered -o {output.filtered}; module load snpEff/4.3t; java -Xmx12g -jar $SNPEFF_JAR -v {params.snpeffgenome} -c {params.effconfig} -interval {input.targets} -cancer -canon -csvStats {output.csvstats} -stats {output.htmlstats} {output.filtered} > {output.snpeffout}; sed -ie 's/TUMOR/{params.tumorsample}/g' {output.filtered}"


elif config['project']['annotation'] == "mm10":
  rule gatk_merge_mutect2_chrom:
    input: vcf1=config['project']['workpath']+"/mutect2_out/chrom_files/{x}_1.vcf",
            vcf2=config['project']['workpath']+"/mutect2_out/chrom_files/{x}_2.vcf",
            vcf3=config['project']['workpath']+"/mutect2_out/chrom_files/{x}_3.vcf",
            vcf4=config['project']['workpath']+"/mutect2_out/chrom_files/{x}_4.vcf",
            vcf5=config['project']['workpath']+"/mutect2_out/chrom_files/{x}_5.vcf",
            vcf6=config['project']['workpath']+"/mutect2_out/chrom_files/{x}_6.vcf",
            vcf7=config['project']['workpath']+"/mutect2_out/chrom_files/{x}_7.vcf",
            vcf8=config['project']['workpath']+"/mutect2_out/chrom_files/{x}_8.vcf",
            vcf9=config['project']['workpath']+"/mutect2_out/chrom_files/{x}_9.vcf",
            vcf10=config['project']['workpath']+"/mutect2_out/chrom_files/{x}_10.vcf",
            vcf11=config['project']['workpath']+"/mutect2_out/chrom_files/{x}_11.vcf",
            vcf12=config['project']['workpath']+"/mutect2_out/chrom_files/{x}_12.vcf",
            vcf13=config['project']['workpath']+"/mutect2_out/chrom_files/{x}_13.vcf",
            vcf14=config['project']['workpath']+"/mutect2_out/chrom_files/{x}_14.vcf",
            vcf15=config['project']['workpath']+"/mutect2_out/chrom_files/{x}_15.vcf",
            vcf16=config['project']['workpath']+"/mutect2_out/chrom_files/{x}_16.vcf",
            vcf17=config['project']['workpath']+"/mutect2_out/chrom_files/{x}_17.vcf",
            vcf18=config['project']['workpath']+"/mutect2_out/chrom_files/{x}_18.vcf",
            vcf19=config['project']['workpath']+"/mutect2_out/chrom_files/{x}_19.vcf",
            vcfX=config['project']['workpath']+"/mutect2_out/chrom_files/{x}_X.vcf",
            vcfY=config['project']['workpath']+"/mutect2_out/chrom_files/{x}_Y.vcf",
            targets=config['project']['workpath']+"/exome_targets.bed"
    output: vcf=config['project']['workpath']+"/mutect2_out/{x}_mutect2.vcf",
            snps=config['project']['workpath']+"/mutect2_out/{x}.SNPs.vcf",
            indels=config['project']['workpath']+"/mutect2_out/{x}.INDELs.vcf",
            flagsnps=config['project']['workpath']+"/mutect2_out/{x}.flaggedSNPs.vcf",
            flagindels=config['project']['workpath']+"/mutect2_out/{x}.flaggedINDELs.vcf",
            flagged=config['project']['workpath']+"/mutect2_out/{x}.flagged.vcf",
            filtered=config['project']['workpath']+"/mutect2_out/{x}.FINALmutect2.vcf",
            snpeffout=config['project']['workpath']+"/mutect2_out/{x}.snpeff.out",
            csvstats=config['project']['workpath']+"/mutect2_out/{x}.mutect2.stats.csv",
            htmlstats=config['project']['workpath']+"/mutect2_out/{x}.mutect2.stats.html",
    params: tumorsample=lambda wildcards: config['project']['units'][wildcards.x],dir=config['project']['workpath'],gatk=config['bin'][pfamily]['GATK'],genome=config['references'][pfamily]['GENOME'],targets=config['references'][pfamily]['REFFLAT'],snpeff=config['bin'][pfamily]['SNPEFF'],snpeffgenome=config['references'][pfamily]['SNPEFF_GENOME'],effconfig=config['references'][pfamily]['SNPEFF_CONFIG'],rname="pl:merge.mutect2"
    shell: "module load GATK/3.8-0; GATK -m 64G CombineVariants -R {params.genome} --filteredrecordsmergetype KEEP_UNCONDITIONAL --assumeIdenticalSamples -o {output.vcf} --variant {input.vcf1} --variant {input.vcf2} --variant {input.vcf3} --variant {input.vcf4} --variant {input.vcf5} --variant {input.vcf6} --variant {input.vcf7} --variant {input.vcf8} --variant {input.vcf9} --variant {input.vcf10} --variant {input.vcf11} --variant {input.vcf12} --variant {input.vcf13} --variant {input.vcf14} --variant {input.vcf15} --variant {input.vcf16} --variant {input.vcf17} --variant {input.vcf18} --variant {input.vcf19} --variant {input.vcfX} --variant {input.vcfY}; GATK -m 120G SelectVariants -R {params.genome} --variant {output.vcf} -selectType SNP --excludeFiltered -o {output.snps}; GATK -m 120G SelectVariants -R {params.genome} --variant {output.vcf} -selectType INDEL --excludeFiltered -o {output.indels}; GATK -m 48G VariantFiltration -R {params.genome} --variant {output.snps} --filterExpression \"FS > 60.0 || SOR > 3.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0\" --filterName \"my_snp_filter\" -o {output.flagsnps}; GATK -m 48G VariantFiltration -R {params.genome} --variant {output.indels} --filterExpression \"FS > 200.0 || SOR > 10.0 || ReadPosRankSum < -20.0\" --filterName \"my_indel_filter\" -o {output.flagindels}; GATK -m 48G CombineVariants -R {params.genome} --variant {output.flagsnps} --variant {output.flagindels} -o {output.flagged} --assumeIdenticalSamples --filteredrecordsmergetype KEEP_UNCONDITIONAL --genotypemergeoption UNSORTED; GATK -m 48G SelectVariants -R {params.genome} --variant {output.flagged} --excludeFiltered -o {output.filtered}; module load snpEff/4.3t; java -Xmx12g -jar $SNPEFF_JAR -v {params.snpeffgenome} -c {params.effconfig} -interval {input.targets} -cancer -canon -csvStats {output.csvstats} -stats {output.htmlstats} {output.filtered} > {output.snpeffout}; sed -ie 's/TUMOR/{params.tumorsample}/g' {output.filtered}"