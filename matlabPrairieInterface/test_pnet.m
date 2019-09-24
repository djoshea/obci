%% Clean up
% pnet('closeall');
% sock = [];

%%
if ~exist('sock', 'var') || isempty(sock);
    sock = pnet('udpsocket', 10001, 'broadcast');
    if sock == -1
        error('udpsocket');
    end
%     pnet(sock, 'udpconnect', '192.168.20.2', 10002);
end

maxSize = 1500;
size = pnet(sock, 'readpacket', maxSize, 'noblock');
data = pnet(sock,'read', 'noblock')