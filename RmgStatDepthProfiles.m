function y=RmgStatDepthProfiles(RmgData,depths,massfactor)

    for i=1:length(RmgData)
        RmgStat(i)=RmgStats(RmgData(i));
    end

    subplot(1,4,1)
    plot([RmgStat.sIRMperVol]*massfactor,depths,'x');
    xlabel('A m^2 / kg');
    title(['IRM @ ' num2str(RmgStat(1).dfIRMdBatField) ' ' RmgStat(1).units.Hcr]);
    ylabel('depth');
    
    subplot(1,4,2)
    
    plot([RmgStat.ARMsusceptibilityToIRM],depths,'x');
    xlabel(RmgStat(1).units.ARMsusceptibilityToIRM);
    title('\chi_{ARM} / IRM');

    subplot(1,4,3)
    
    plot([RmgStat.CisowskiR],depths,'bx');
    hold on; 
    plot([RmgStat.DPofIRMAcq],depths,'r.');
    title('R and DP of IRM Acq');
    legend('R','DP - IRM Acq');
    
    subplot(1,4,4)
    
    plot([RmgStat.Hcr],depths,'bx--')
    hold on;
    plot([RmgStat.MAFofIRM],depths,'r.');
    plot([RmgStat.MDFofIRM],depths,'g.');
    plot([RmgStat.MDFofARM],depths,'ms');
    plot([RmgStat.MDFofIRMatARM],depths,'ys');
    
    legend('H_{cr}','IRM - MAF','IRM - MDF', 'ARM - MDF','IRM_{ARM} - MDF')
    title ('H_{cr}, MAF, and MDF')
    xlabel(RmgStat(1).units.Hcr);
end