console.log("init RS for name,", process.env.RSNAME);
rs.initiate({
  _id: process.env.RSNAME,
  members: [
    { _id: 0, host: "on:27017" },
    { _id: 1, host: "o2:27017" },
    { _id: 2, host: "o3:27017" },
  ],
  settings: {
    heartbeatIntervalMillis: 30000,
    heartbeatTimeoutSecs: 40,
  },
});
