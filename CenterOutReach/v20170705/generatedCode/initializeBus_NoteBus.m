function bus = initializeBus_NoteBus()
%#codegen
% DO NOT EDIT: Auto-generated by 
%   BusSerialize.writeInitializeBusCode('NoteBus')

    bus.noteType = NoteType.Info;
    coder.varsize('bus.note', 50000, true);
    bus.note = zeros([0 1], 'uint8');

end