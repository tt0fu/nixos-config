.pragma library

function real(raw, fallback) {
    const value = parseFloat(raw);
    return isFinite(value) ? value : fallback;
}

function string(raw, fallback) {
    return raw === undefined || raw === null || raw === "" ? fallback : raw;
}
