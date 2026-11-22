.pragma library

const sinkMuted = "\ueee8";
const sinkHigh = "\uf028";
const sinkMedium = "\uf027";
const sinkLow = "\uf026";
const sourceMuted = "\udb80\udf6d";
const sourceUnmuted = "\udb80\udf6c";

const check = "\uf00c";
const cross = "\uf00d";

function sink(volume, muted) {
    if (muted)
        return sinkMuted;
    if (volume * 3 >= 2)
        return sinkHigh;
    if (volume * 3 <= 1)
        return sinkLow;
    return sinkMedium;
}

function source(muted) {
    return muted ? sourceMuted : sourceUnmuted;
}

function sinkText(volume, muted) {
    return muted ? sink(volume, muted) : sink(volume, muted) + " " + Math.round(volume * 100) + "%";
}

function sourceText(volume, muted) {
    return muted ? source(muted) : source(muted) + " " + Math.round(volume * 100) + "%";
}
