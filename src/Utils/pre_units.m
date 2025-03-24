%% File Duties
% Deals with the units of the SAP2000 model

%%

w = warning ('off','all');

Orig_config = readtable(ofile,'Sheet','Program Control','ReadVariableNames',false);
Orig_config = table2cell(Orig_config);
Orig_config = char(Orig_config(3,find(contains(Orig_config(1,:),'CurrUnits'))));

if isempty(Orig_config)
    Orig_config = readtable(ofile,'Sheet','Program Control');
    Orig_config = table2cell(Orig_config);
    pos = [];
    cont = 1;
    while isempty(pos)
        pos = find(contains(Orig_config(cont,:),'CurrUnits'));
        cont = cont+1;
    end
    cont = cont-1;
    Txt_Orig_config = char(Orig_config(cont+2,pos));
    
    switch Txt_Orig_config
        case 'lb, in, F'
            Orig_config = 1;
        case 'lb, ft, F'
            Orig_config = 2;
        case 'Kip, in, F'
            Orig_config = 3;
        case 'kip, ft, F'
            Orig_config = 4;
        case 'KN, mm, C'
            Orig_config = 5;
        case 'KN, m, C'
            Orig_config = 6;
        case 'kgf, mm, C'
            Orig_config = 7;
        case 'kgf, m, C'
            Orig_config = 8;
        case 'N, mm, C'
            Orig_config = 9;
        case 'N, m, C'
            Orig_config = 10;
        case 'Tonf, mm, C'
            Orig_config = 11;
        case 'Tonf, m, C'
            Orig_config = 12;
        case 'KN, cm, C'
            Orig_config = 13;
        case 'kgf, cm, C'
            Orig_config = 14;
        case 'N, cm, C'
            Orig_config = 15;
        case 'Tonf, cm, C'
            Orig_config = 16;
    end
    
    
end

switch Orig_config
    case 1
        ret = SapModel.SetPresentUnits(SAP2000v1.eUnits.lb_in_F);  % lb_in_F = 1
    case 2
        ret = SapModel.SetPresentUnits(SAP2000v1.eUnits.lb_ft_F);  % lb_ft_F = 2
    case 3
        ret = SapModel.SetPresentUnits(SAP2000v1.eUnits.kip_in_F);  % kip_in_F = 3
    case 4
        ret = SapModel.SetPresentUnits(SAP2000v1.eUnits.kip_ft_F);  % kip_ft_F = 4
    case 5
        ret = SapModel.SetPresentUnits(SAP2000v1.eUnits.kN_mm_C);  % kN_mm_C = 5
    case 6
        ret = SapModel.SetPresentUnits(SAP2000v1.eUnits.kN_m_C);  % kN_m_C = 6
    case 7
        ret = SapModel.SetPresentUnits(SAP2000v1.eUnits.kgf_mm_C);  % kgf_mm_C = 7
    case 8
        ret = SapModel.SetPresentUnits(SAP2000v1.eUnits.kgf_m_C);  % kgf_m_C = 8
    case 9
        ret = SapModel.SetPresentUnits(SAP2000v1.eUnits.N_mm_C);  % N_mm_C = 9
    case 10
        ret = SapModel.SetPresentUnits(SAP2000v1.eUnits.N_m_C);  % N_m_C = 10
    case 11
        ret = SapModel.SetPresentUnits(SAP2000v1.eUnits.Ton_mm_C);  % Ton_mm_C = 11
    case 12
        ret = SapModel.SetPresentUnits(SAP2000v1.eUnits.Ton_m_C);  % Ton_m_C = 12
    case 13
        ret = SapModel.SetPresentUnits(SAP2000v1.eUnits.kN_cm_C);  % kN_cm_C = 13
    case 14
        ret = SapModel.SetPresentUnits(SAP2000v1.eUnits.kgf_cm_C);  % kgf_cm_C = 14
    case 15
        ret = SapModel.SetPresentUnits(SAP2000v1.eUnits.N_cm_C);  % N_cm_C = 15
    case 16
        ret = SapModel.SetPresentUnits(SAP2000v1.eUnits.Ton_cm_C);  % Ton_cm_C = 16
end
w = warning ('on','all');