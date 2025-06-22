{
  inputs,
  pkgs,
  userSettings,
  ...
}:

{
  services.zapret = {
    enable = true;
    params = [
      "nfqws --filter-udp=443 --hostlist-domains=cloudflare-ech.com,dis.gd,discord-attachments-uploads-prd.storage.googleapis.com,discord.app,discord.co,discord.com,discord.design,discord.dev,discord.gift,discord.gifts,discord.gg,discord.media,discord.new,discord.status,discord.store,discordapp.com,discordapp.net,discordcdn.com,discordmerch.com,discordpartygames.com,discordsays.com,discordsez.com,discord-activities.com,discordactivities.com stable.dl2.discordapp.net --dpi-desync=fake --dpi-desync-repeats=6 --new --filter-udp=50000-50100 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-repeats=6 --new --filter-tcp=443 --hostlist-domains=cloudflare-ech.com,dis.gd,discord-attachments-uploads-prd.storage.googleapis.com,discord.app,discord.co,discord.com,discord.design,discord.dev,discord.gift,discord.gifts,discord.gg,discord.media,discord.new,discord.status,discord.store,discordapp.com,discordapp.net,discordcdn.com,discordmerch.com,discordpartygames.com,discordsays.com,discordsez.com,discord-activities.com,discordactivities.com stable.dl2.discordapp.net --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-autottl --dpi-desync-fooling=badseq --dpi-desync-repeats=8"
    ];
    udpSupport = true;
    udpPorts = [
      "50000:50100"
      "443"
    ];
  };
}
