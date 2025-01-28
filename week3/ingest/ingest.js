import mgeneratejs from "mgeneratejs";
import { MongoClient } from "mongodb";
import {
  templateDelivery,
  templatePayment,
  templateTracking,
} from "./template.js";

function removeNullFields(obj) {
  for (let field in obj) {
    if (obj[field] === null) {
      delete obj[field];
    } else if (typeof obj[field] === "object") {
      removeNullFields(obj[field]);
    }
  }
}

// generate 1000 records
function genDelivery() {
  let doc;
  doc = mgeneratejs(templateDelivery);
  removeNullFields(doc);

  let trlen = mgeneratejs({ trlen: { $integer: { min: 1, max: 9 } } });
  for (let i = 0; i < trlen.trlen; i++) {
    let tracking = mgeneratejs(templateTracking);
    doc.tracking.push(tracking);
  }
  return doc;
}

function getPayment(trno) {
  let doc;
  doc = mgeneratejs(templatePayment);
  // doc._id = trno;
  removeNullFields(doc);
  return doc;
}

function genDocs1batch(nDocs) {
  let deliveries = [];
  let payments = [];
  for (let i = 0; i < nDocs; i++) {
    if (i % 5 === 0) {
      process.stdout.write(".");
      if (i !== 0 && i % 150 === 0) {
        console.log();
      }
    }
    const del = genDelivery();
    const pay = getPayment(del.trackingno);
    deliveries.push(del);
    payments.push(pay);
  }
  console.log();
  return [deliveries, payments];
}

async function main(nDocs, oneBatch) {
  let dels, pays;

  // init mongo client
  const uri = "mongodb://pm:pm1234@m1,m2,m3";
  const client = new MongoClient(uri);
  try {
    await client.connect();
    const database = client.db("shipdb");
    const deliveryCollection = database.collection("delivery");
    const paymentCollection = database.collection("payment");

    await deliveryCollection.drop();
    await paymentCollection.drop();

    await deliveryCollection.createIndexes([
      {
        key: { trackingno: 1 },
        name: "trackno",
      },
      {
        key: {
          "from.country": 1,
          shippedOn: 1,
          "to.country": 1,
          shipmentRef: 1,
        },
        name: "fromOnToRef",
      },
      {
        key: { shippedOn: 1 },
        name: "on",
        expireAfterSeconds: 60 * 60 * 24 * 30 * 4, // 4 months
      },
    ]);
    await paymentCollection.createIndexes([
      {
        key: { timestamp: 1 },
        name: "timestamp",
        expireAfterSeconds: 60 * 60 * 24 * 30 * 4, // 4 months
      },
    ]);

    let nBatch = 0;
    while (nDocs > 0) {
      console.log(`#### Batch ${++nBatch}`);
      if (nDocs < oneBatch) {
        [dels, pays] = genDocs1batch(nDocs);
      } else {
        [dels, pays] = genDocs1batch(oneBatch);
      }
      nDocs -= oneBatch;

      await deliveryCollection.insertMany(dels);
      await paymentCollection.insertMany(pays);
    }
  } catch (e) {
    console.error("An error occurred while processing the batch:", e);
  } finally {
    await client.close();
  }
}

await main(250_000, 1_000);
