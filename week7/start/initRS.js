rs.initiate({
  _id: process.env.RSNAME,
  members: [
    { _id: 0, host: "m1:27017" },
    { _id: 1, host: "m2:27017" },
    { _id: 2, host: "m3:27017" },
  ],
  settings: {
    heartbeatIntervalMillis: 30000,
    heartbeatTimeoutSecs: 40,
  },
});
