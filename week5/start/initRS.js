rs.initiate({
  _id: process.env.RSNAME,
  members: [
    { _id: 0, host: "m1:27017" },
    { _id: 1, host: "m2:27017" },
    { _id: 2, host: "m3:27017" },
    { _id: 3, host: "m4:27017" },
    { _id: 4, host: "m5:27017" },
    { _id: 5, host: "m6:27017", priority: 0, hidden: true },
  ],
  settings: {
    heartbeatIntervalMillis: 30000,
    heartbeatTimeoutSecs: 40,
  },
});
