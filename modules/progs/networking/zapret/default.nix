{
  os =
    { ... }:
    {
      services.zapret = {
        enable = true;
        params =
          let
            profiles = [
              # "--dpi-desync=fake --dpi-desync-ttl=11 --orig-ttl=1 --orig-mod-start=s1 --orig-mod-cutoff=d1 --dpi-desync-fake-tls=0x00000000 --dpi-desync-fake-tls=! --dpi-desync-fake-tls-mod=rnd,rndsni,dupsid"
              # "--dpi-desync=fake --dpi-desync-fooling=badseq --dpi-desync-fake-tls=0x00000000 --dpi-desync-fake-tls=! --dpi-desync-fake-tls-mod=rnd,rndsni,dupsid"
              # "--dpi-desync=fake --dpi-desync-fooling=ts --dpi-desync-fake-tls=0x00000000 --dpi-desync-fake-tls=! --dpi-desync-fake-tls-mod=rnd,rndsni,dupsid"
              # "--dpi-desync=fake --dpi-desync-fooling=md5sig --dup=1 --dup-cutoff=n2 --dup-fooling=md5sig --dpi-desync-fake-tls=0x00000000 --dpi-desync-fake-tls=! --dpi-desync-fake-tls-mod=rnd,rndsni,dupsid"
              # "--dpi-desync=hostfakesplit --dpi-desync-ttl=11"
              # "--dpi-desync=hostfakesplit --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=0"
              # "--dpi-desync=hostfakesplit --dpi-desync-fooling=ts"
              # "--dpi-desync=hostfakesplit --dpi-desync-fooling=md5sig"
              # "--dpi-desync=fake --dpi-desync-ttl=1 --dpi-desync-autottl=-1 --orig-ttl=1 --orig-mod-start=s1 --orig-mod-cutoff=d1 --dpi-desync-fake-tls=0x00000000 --dpi-desync-fake-tls=! --dpi-desync-fake-tls-mod=rnd,rndsni,dupsid"
              # "--dpi-desync=hostfakesplit --dpi-desync-ttl=1 --dpi-desync-autottl=-1"
              # "--dpi-desync=hostfakesplit --dpi-desync-ttl=1 --dpi-desync-autottl=-2"
              # "--dpi-desync=hostfakesplit --dpi-desync-ttl=1 --dpi-desync-autottl=-3"
              # "--dpi-desync=hostfakesplit --dpi-desync-ttl=1 --dpi-desync-autottl=-4 --dpi-desync-hostfakesplit-mod=altorder=1 --dpi-desync-hostfakesplit-midhost=midsld"

              # "--filter-udp=443 --hostlist=${./list-general.txt} --dpi-desync=fake --dpi-desync-repeats=6"
              # "--filter-udp=50000-50100 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-repeats=6"
              # "--filter-tcp=443 --hostlist=${./list-general.txt} --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-autottl --dpi-desync-fooling=badseq --dpi-desync-repeats=8"

              # "--filter-tcp=80,443,2053,2083,2087,2096,8443,12 --filter-udp=443,19294-19344,50000-50100,12 --hostlist=${./list-general.txt} --hostlist-exclude=${./list-exclude.txt} --ipset-exclude=${./ipset-exclude.txt} --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=${./quic_initial_www_google_com.bin}"
              # "--filter-udp=19294-19344,50000-50100 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-repeats=6"
              # "--filter-tcp=2053,2083,2087,2096,8443 --hostlist-domains=discord.media --dpi-desync=multisplit --dpi-desync-split-seqovl=568 --dpi-desync-split-pos=1 --dpi-desync-split-seqovl-pattern=${./tls_clienthello_4pda_to.bin}"
              # "--filter-tcp=443 --hostlist=${./list-google.txt} --ip-id=zero --dpi-desync=multisplit --dpi-desync-split-seqovl=681 --dpi-desync-split-pos=1 --dpi-desync-split-seqovl-pattern=${./tls_clienthello_www_google_com.bin}"
              # "--filter-tcp=80,443 --hostlist=${./list-general.txt} --hostlist-exclude=${./list-exclude.txt} --ipset-exclude=${./ipset-exclude.txt} --dpi-desync=multisplit --dpi-desync-split-seqovl=568 --dpi-desync-split-pos=1 --dpi-desync-split-seqovl-pattern=${./tls_clienthello_4pda_to.bin}"
              # "--filter-udp=443 --ipset=${./ipset-all.txt} --hostlist-exclude=${./list-exclude.txt} --ipset-exclude=${./ipset-exclude.txt} --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=${./quic_initial_www_google_com.bin}"
              # "--filter-tcp=80,443,12 --ipset=${./ipset-all.txt} --hostlist-exclude=${./list-exclude.txt} --ipset-exclude=${./ipset-exclude.txt} --dpi-desync=multisplit --dpi-desync-split-seqovl=568 --dpi-desync-split-pos=1 --dpi-desync-split-seqovl-pattern=${./tls_clienthello_4pda_to.bin}"
              # "--filter-udp=12 --ipset=${./ipset-all.txt} --ipset-exclude=${./ipset-exclude.txt} --dpi-desync=fake --dpi-desync-autottl=2 --dpi-desync-repeats=12 --dpi-desync-any-protocol=1 --dpi-desync-fake-unknown-udp=${./quic_initial_www_google_com.bin} --dpi-desync-cutoff=n2"
            ];
            command = "nfqws " + (builtins.concatStringsSep " --new " profiles);
          in
          [
            command
          ];
        udpSupport = true;
        udpPorts = [
          "12"
          "443"
          "19294:19344"
          "50000:50100"
        ];
      };
    };
}
