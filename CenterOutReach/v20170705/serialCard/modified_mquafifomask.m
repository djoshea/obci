function modified_mquafifomask( when, nchans, form )
% mquafifomask is used by the FIFO output component version serial blocks
% This MATLAB file controls parameter visibility and transfers parameters
% to the blocks inside.
  
% when selects how this function is called.
% when == 1 when called from mask initialization
% when == 2 when called from a change in any value in the mask
% Copyright 1996-2011 The MathWorks, Inc.


if when == 1
  
  % if form == 1 this is an RS232 block
  % if form == 2 this is an RS422/485 block
  
%disp('mask init');

  params = get_param( gcb, 'MaskValues' );
  %set_param( [gcb,'/IRQ Source'], 'slot', '-1' );

  % params:   This list must agree with the mask.
  %    1 == group
  %    2 == port
  %    3 == irqnum  Using AUTO now, ignoring this parameter
  %    4 == slot
  %
  %    5 == baud
  %    6 == parity
  %    7 == ndata
  %    8 == nstop
  %    9 == fifomode
  %   10 == rlevel
  %   11 == automode
  %   12 == xmtfifosize
  %   13 == xmtdatatype
  %   14 == rcvfifosize
  %
  %   15 start over with baud
  
  for port = 1:nchans
    s = 5 + (port - 1) * 10;
    set_param( [ gcb,'/Setup', num2str(port) ], 'baud', params{s} );
    set_param( [ gcb,'/Setup', num2str(port) ], 'parity', params{s + 1} );
    set_param( [ gcb,'/Setup', num2str(port) ], 'width', num2str(params{s + 2}) );
    set_param( [ gcb,'/Setup', num2str(port) ], 'nstop', num2str(params{s + 3}) );
    set_param( [ gcb,'/Setup', num2str(port) ], 'fmode', params{s + 4} );
    set_param( [ gcb,'/Setup', num2str(port) ], 'rlevel', params{s + 5} );
    if form == 1 % rs232 block
      set_param( [ gcb,'/Setup', num2str(port) ], 'ctsmode', params{s + 6} );
    end
    set_param( [ gcb,'/FIFO write ', num2str(port) ], 'size', params{s + 7} );
    set_param( [ gcb,'/FIFO write ', num2str(port) ], 'inputtype', params{s + 8} );
    % Prepare the transmit fifo overflow message id.
    %irq = get_param( [gcb,'/IRQ Source'], 'irqNo' );
    irq = 'Auto (PCI only)';
    tmpid = ['XMT channel ', num2str(port), ', IRQ ', num2str(irq)];
    set_param( [ gcb,'/FIFO write ', num2str(port) ], 'id', tmpid );

    set_param( [ gcb,'/RS232 ISR/While Iterator Subsystem/FIFO write ', num2str(port) ], 'size', params{s + 9} );
    if form == 2 % rs422/485 block
      set_param( [ gcb,'/RS232 ISR/While Iterator Subsystem/Write HW FIFO', num2str(port) ], 'onxmt', params{s + 6} );
    end
    % Prepare the receive fifo overflow message id.
    tmpid = ['RCV channel ', num2str(port), ', IRQ ', num2str(irq)];
    set_param( [ gcb,'/RS232 ISR/While Iterator Subsystem/FIFO write ', num2str(port) ], 'id', tmpid );

  end
end

if when == 2
%disp('group changed');
  displaystr = 'on';  % parameter group is always on
  group = get_param( gcb, 'group' );
  groupok = false;
  if strcmp( group, 'Board Setup' )
    groupok = true; %#ok
                    % Using Auto IRQ now, hide the parameter.
    displaystr = [displaystr,',off,off,on'];  % not port, irq, yes to  slot
    for pt = 1:nchans  % each port has 10 parameters, all off in board setup
      displaystr = [displaystr,',off,off,off,off,off,off,off,off,off,off']; %#ok
    end
  else

    displaystr = [displaystr,',on,off,off'];  % not board setup, port on, irq and slot off

    port = str2num(get_param( gcb, 'port' )); %#ok
    if port > 1
      for pt = 1:port-1
        displaystr = [displaystr,',off,off,off,off,off,off,off,off,off,off']; %#ok
      end
    end
    
    if strcmp( group, 'Basic Setup' )
      groupok = true;
      displaystr = [displaystr,',on,on,on,on,on,on,on,off,off,off'];
    end
    if strcmp( group, 'FIFO Setup' )
      groupok = true;
      displaystr = [displaystr,',off,off,off,off,off,off,off,on,on,on'];
    end
    if groupok == false
      disp( 'Illegal parameter group' );
    end
  
    if port < nchans
      for pt = port+1:nchans
        displaystr = [displaystr,',off,off,off,off,off,off,off,off,off,off']; %#ok
      end
    end
  end
  set_param( gcb, 'MaskVisibilityString', displaystr );
  
end

if when == 3  % called as an InitFcn in the callbacks section of the block properties
  % InitFcn for cross block checking. PCI serial boards
  
  masktype = get_param( gcb, 'MaskType' );
  slot = get_param( gcb, 'slot' );
  sameserial = find_system( bdroot, 'FollowLinks', 'on', 'LookUnderMasks', 'all', 'MaskType', masktype, 'slot', slot );
  if length(sameserial) > 1
    error('xPCTarget:Quatech:DupBlock',...
          'This block uses the same board as another block.  This won''t work correctly.');
  end
  
end

