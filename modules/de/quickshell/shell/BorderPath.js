.pragma library

function toStringRounded(value) {
  if (!isFinite(value)) {
    value = 0;
  }
  const rounded = Math.round(value * 1000) / 1000;
  return Object.is(rounded, -0) ? "0" : String(rounded);
}

function build(notches, view, radius) {
  const L = view.x;
  const T = view.y;
  const R = view.x + view.width;
  const B = view.y + view.height;
  const viewRadius = Math.max(
    0,
    Math.min(radius, view.width / 2, view.height / 2),
  );

  const allNotches = notches || [];
  const activeNotches = allNotches.filter((n) => n && n.active !== false);

  function activeNotchesOfType(type) {
    return activeNotches.filter((n) => n.type === type);
  }

  function allNotchesOfType(type) {
    return allNotches.find((n) => n && n.type === type) || null;
  }

  const top = activeNotchesOfType("top").sort((a, b) => a.x0 - b.x0);
  const right = activeNotchesOfType("right").sort((a, b) => a.y0 - b.y0);
  const bottom = activeNotchesOfType("bottom").sort((a, b) => b.x1 - a.x1);
  const left = activeNotchesOfType("left").sort((a, b) => b.y1 - a.y1);

  const topLeftInfo = allNotchesOfType("top-left");
  const topRightInfo = allNotchesOfType("top-right");
  const bottomRightInfo = allNotchesOfType("bottom-right");
  const bottomLeftInfo = allNotchesOfType("bottom-left");

  const topLeft =
    topLeftInfo && topLeftInfo.active !== false ? topLeftInfo : null;
  const topRight =
    topRightInfo && topRightInfo.active !== false ? topRightInfo : null;
  const bottomRight =
    bottomRightInfo && bottomRightInfo.active !== false
      ? bottomRightInfo
      : null;
  const bottomLeft =
    bottomLeftInfo && bottomLeftInfo.active !== false ? bottomLeftInfo : null;

  function retreatRadius(info, clearance) {
    if (!info || info.active !== false) {
      return viewRadius;
    }
    return viewRadius * Math.max(0, Math.min(1, clearance / viewRadius));
  }

  const topLeftCornerRadius = retreatRadius(
    topLeftInfo,
    topLeftInfo ? Math.max(L - topLeftInfo.x1, T - topLeftInfo.y1) : 0,
  );
  const topRightCornerRadius = retreatRadius(
    topRightInfo,
    topRightInfo ? Math.max(topRightInfo.x0 - R, T - topRightInfo.y1) : 0,
  );
  const bottomRightCornerRadius = retreatRadius(
    bottomRightInfo,
    bottomRightInfo
      ? Math.max(bottomRightInfo.x0 - R, bottomRightInfo.y0 - B)
      : 0,
  );
  const bottomLeftCornerRadius = retreatRadius(
    bottomLeftInfo,
    bottomLeftInfo ? Math.max(L - bottomLeftInfo.x1, bottomLeftInfo.y0 - B) : 0,
  );

  function topRadius(n) {
    return Math.max(0, Math.min(radius, (n.x1 - n.x0) / 2, (n.y1 - T) / 2));
  }
  function bottomRadius(n) {
    return Math.max(0, Math.min(radius, (n.x1 - n.x0) / 2, (B - n.y0) / 2));
  }
  function leftRadius(n) {
    return Math.max(0, Math.min(radius, (n.y1 - n.y0) / 2, (n.x1 - L) / 2));
  }
  function rightRadius(n) {
    return Math.max(0, Math.min(radius, (n.y1 - n.y0) / 2, (R - n.x0) / 2));
  }

  let path = "";
  let x = 0;
  let y = 0;

  function line(nx, ny) {
    path += " L " + toStringRounded(nx) + " " + toStringRounded(ny);
    x = nx;
    y = ny;
  }

  function arc(nx, ny, r, sweep) {
    if (r <= 0.001) {
      line(nx, ny);
      return;
    }
    path +=
      " A " +
      toStringRounded(r) +
      " " +
      toStringRounded(r) +
      " 0 0 " +
      sweep +
      " " +
      toStringRounded(nx) +
      " " +
      toStringRounded(ny);
    x = nx;
    y = ny;
  }

  let startX = L + topLeftCornerRadius;
  if (topLeft) {
    const r = Math.min(topRadius(topLeft), leftRadius(topLeft));
    startX = Math.max(L, topLeft.x1 + r);
  }
  path = "M " + toStringRounded(startX) + " " + toStringRounded(T);
  x = startX;
  y = T;

  for (const n of top) {
    const r = topRadius(n);
    if (n.x0 - r < x - 0.01) {
      continue;
    }
    line(n.x0 - r, T);
    arc(n.x0, T + r, r, 1);
    line(n.x0, n.y1 - r);
    arc(n.x0 + r, n.y1, r, 0);
    line(n.x1 - r, n.y1);
    arc(n.x1, n.y1 - r, r, 0);
    line(n.x1, T + r);
    arc(n.x1 + r, T, r, 1);
  }

  if (topRight) {
    const r = Math.min(topRadius(topRight), rightRadius(topRight));
    line(topRight.x0 - r, T);
    arc(topRight.x0, T + r, r, 1);
    line(topRight.x0, topRight.y1 - r);
    arc(topRight.x0 + r, topRight.y1, r, 0);
    line(R - r, topRight.y1);
    arc(R, topRight.y1 + r, r, 1);
  } else {
    line(R - topRightCornerRadius, T);
    arc(R, T + topRightCornerRadius, topRightCornerRadius, 1);
  }

  for (const n of right) {
    const r = rightRadius(n);
    if (n.y0 - r < y - 0.01) continue;
    line(R, n.y0 - r);
    arc(R - r, n.y0, r, 1);
    line(n.x0 + r, n.y0);
    arc(n.x0, n.y0 + r, r, 0);
    line(n.x0, n.y1 - r);
    arc(n.x0 + r, n.y1, r, 0);
    line(R - r, n.y1);
    arc(R, n.y1 + r, r, 1);
  }

  if (bottomRight) {
    const r = Math.min(bottomRadius(bottomRight), rightRadius(bottomRight));
    line(R, bottomRight.y0 - r);
    arc(R - r, bottomRight.y0, r, 1);
    line(bottomRight.x0 + r, bottomRight.y0);
    arc(bottomRight.x0, bottomRight.y0 + r, r, 0);
    line(bottomRight.x0, B - r);
    arc(bottomRight.x0 - r, B, r, 1);
  } else {
    line(R, B - bottomRightCornerRadius);
    arc(R - bottomRightCornerRadius, B, bottomRightCornerRadius, 1);
  }

  for (const n of bottom) {
    const r = bottomRadius(n);
    if (n.x1 + r > x + 0.01) continue;
    line(n.x1 + r, B);
    arc(n.x1, B - r, r, 1);
    line(n.x1, n.y0 + r);
    arc(n.x1 - r, n.y0, r, 0);
    line(n.x0 + r, n.y0);
    arc(n.x0, n.y0 + r, r, 0);
    line(n.x0, B - r);
    arc(n.x0 - r, B, r, 1);
  }

  if (bottomLeft) {
    const r = Math.min(bottomRadius(bottomLeft), leftRadius(bottomLeft));
    line(bottomLeft.x1 + r, B);
    arc(bottomLeft.x1, B - r, r, 1);
    line(bottomLeft.x1, bottomLeft.y0 + r);
    arc(bottomLeft.x1 - r, bottomLeft.y0, r, 0);
    line(L + r, bottomLeft.y0);
    arc(L, bottomLeft.y0 - r, r, 1);
  } else {
    line(L + bottomLeftCornerRadius, B);
    arc(L, B - bottomLeftCornerRadius, bottomLeftCornerRadius, 1);
  }

  for (const n of left) {
    const r = leftRadius(n);
    if (n.y1 + r > y + 0.01) continue;
    line(L, n.y1 + r);
    arc(L + r, n.y1, r, 1);
    line(n.x1 - r, n.y1);
    arc(n.x1, n.y1 - r, r, 0);
    line(n.x1, n.y0 + r);
    arc(n.x1 - r, n.y0, r, 0);
    line(L + r, n.y0);
    arc(L, n.y0 - r, r, 1);
  }

  if (topLeft) {
    const r = Math.min(topRadius(topLeft), leftRadius(topLeft));
    line(L, topLeft.y1 + r);
    arc(L + r, topLeft.y1, r, 1);
    line(topLeft.x1 - r, topLeft.y1);
    arc(topLeft.x1, topLeft.y1 - r, r, 0);
    line(topLeft.x1, T + r);
    arc(topLeft.x1 + r, T, r, 1);
    line(startX, T);
  } else {
    line(L, T + topLeftCornerRadius);
    arc(L + topLeftCornerRadius, T, topLeftCornerRadius, 1);
    line(startX, T);
  }

  return path + " Z";
}

function fillPath(outline, width, height) {
  return (
    "M 0 0 L " +
    toStringRounded(width) +
    " 0 L " +
    toStringRounded(width) +
    " " +
    toStringRounded(height) +
    " L 0 " +
    toStringRounded(height) +
    " Z " +
    outline
  );
}
