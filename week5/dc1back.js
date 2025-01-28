let rsconf = rs.conf();

let m123 = JSON.parse(JSON.stringify(rsconf.members));
m123.forEach((m, i) => {
  m._id = i;
  m.host = `m${i + 1}:27017`;
  m.secondaryDelaySecs = 0;
});
rsconf.members = [...m123, ...rsconf.members];

rsconf.members[5].priority = 0;
rsconf.members[5].hidden = true;

rs.reconfig(rsconf, { force: true });
