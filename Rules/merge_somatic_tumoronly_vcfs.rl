rule merge_somatic_tumoronly_vcfs:
    input: mutect=config['project']['workpath']+"/mutect_out/{x}.FINAL.vcf",
           mutect2=config['project']['workpath']+"/mutect2_out/{x}.FINALmutect2.vcf",
           vardict=config['project']['workpath']+"/vardict_out/{x}.FINAL.vcf",
    output: mergedvcf=config['project']['workpath']+"/merged_somatic_variants/{x}.merged.vcf",
            csvstats=config['project']['workpath']+"/merged_somatic_variants/{x}.mutect.stats.csv",
            htmlstats=config['project']['workpath']+"/merged_somatic_variants/{x}.mutect.stats.html",
            out=config['project']['workpath']+"/merged_somatic_variants/{x}.snpeff.out"
    params: gres="lscratch:100",gatk=config['bin'][pfamily]['GATK'],genome=config['references'][pfamily]['GENOME'],snpsites=config['references'][pfamily]['SNPSITES'],snpeffgenome=config['references'][pfamily]['SNPEFF_GENOME'],snpeff=config['bin'][pfamily]['SNPEFF'],effconfig=config['references'][pfamily]['SNPEFF_CONFIG'],rname="CombineVariants"
    shell: "mkdir -p merged_somatic_variants; module load GATK/3.8-0; java -Xmx48g -Djava.io.tmpdir=/lscratch/$SLURM_JOBID -jar $GATK_JAR -T CombineVariants -R {params.genome} -nt 8 --filteredrecordsmergetype KEEP_IF_ANY_UNFILTERED --genotypemergeoption PRIORITIZE --rod_priority_list mutect2,vardict,mutect --minimumN 2 -o {output.mergedvcf} --variant:mutect {input.mutect} --variant:mutect2 {input.mutect2} --variant:vardict {input.vardict}; module load snpEff/4.3t; java -Xmx12g -jar $SNPEFF_JAR -v {params.snpeffgenome} -c {params.effconfig} -cancer -canon -csvStats {output.csvstats} -stats {output.htmlstats} -cancerSamples pairs {output.mergedvcf} > {output.out}"