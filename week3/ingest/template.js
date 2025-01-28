const strPool =
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

const templateDelivery = {
  // rfid as 12-octet unique identifier
  //_id: { $oid: {} },

  // trackingno as ranom 14 digits with easy readable constants
  trackingno: {
    $integer: { min: 10000000000000, max: 99999999999999 },
  },

  // status as one of 10 values
  status: {
    $choose: {
      from: [
        "Received",
        "AtOrigin",
        "InCustoms",
        "InTransit",
        "AtDestinationWarehouse",
        "OutOnDelivery",
        "Delivered",
        "Exception",
        "Returned",
      ],
    },
  },
  // scheduledDelivery as a date
  scheduledDelivery: { $date: { min: "2025-01-01", max: "2025-12-31" } },
  // shippedFrom as address subdocument whose fields are
  // country, state/province, city/town, postcode, street, APT&Suite, Dept as optional
  from: {
    country: { $country: {} },
    state: { $state: {} },
    city: { $city: {} },
    postcode: { $postcode: {} },
    street: { $street: {} },
    apt: {
      $string: {
        length: { $integer: { min: 5, max: 10 } },
        pool: strPool,
      },
    },
    dept: {
      $choose: {
        from: [
          null,
          {
            $string: {
              length: { $integer: { min: 5, max: 10 } },
              pool: strPool,
            },
          },
        ],
      },
    },
  },
  // shippedByEmail as email address, optional
  fromEmail: { $choose: { from: [null, { $email: {} }] } },
  // shipmentRef as alphanumeric up to 35 characters
  shipmentRef: {
    $string: {
      length: { $integer: { min: 15, max: 35 } },
      pool: strPool,
    },
  },
  // shippedTo as address subdocument whose fields are the same as shippedFrom
  to: {
    country: { $country: {} },
    state: { $state: {} },
    city: { $city: {} },
    postcode: { $postcode: {} },
    street: { $street: {} },
    apt: {
      $string: {
        length: { $integer: { min: 5, max: 10 } },
        pool: strPool,
      },
    },
    dept: {
      $choose: {
        from: [
          null,
          {
            $string: {
              length: { $integer: { min: 5, max: 10 } },
              pool: strPool,
            },
          },
        ],
      },
    },
  },
  toEmail: { $choose: { from: [null, { $email: {} }] } },
  shippedOn: { $date: { min: "2025-01-01", max: "2025-12-31" } },
  // serviceType as one of 4 values
  serviceType: {
    $choose: { from: ["Express plus", "Express", "Express Saver", "Standard"] },
  },
  // weight as double
  weight: { $float: { min: 0.1, max: 100.0 } },
  // dimension as subdocument with fields length, width, height in cm and oversized as yes/no
  dimension: {
    length: { $float: { min: 10.0, max: 300.0 } },
    width: { $float: { min: 10.0, max: 300.0 } },
    height: { $float: { min: 10.0, max: 300.0 } },
    oversized: { $choose: { from: ["yes", "no"] } },
  },
  // declaredValue optional as double in USD
  declaredValue: {
    $choose: { from: [null, { $float: { min: 10.0, max: 1000.0 } }] },
  },
  multiplePackages: {
    $choose: { from: [null, { $integer: { min: 1, max: 10 } }] },
  },
  additionalFeatures: {
    $choose: {
      from: [
        null,
        {
          $choose: {
            from: ["SignatureRequired", "Insurance", "SaturdayDelivery"],
          },
        },
      ],
    },
  },
  vatNo: {
    $choose: {
      from: [
        null,
        {
          $string: {
            length: { $integer: { min: 10, max: 15 } },
            pool: strPool,
          },
        },
      ],
    },
  },
  tracking: [],
};

const templateTracking = {
  timestamp: { $date: { min: "2025-01-01", max: "2025-12-31" } },

  location: {
    $string: {
      length: { $integer: { min: 5, max: 35 } },
      pool: strPool,
    },
  },
  gpsLoc: {
    lat: { $float: { min: -90.0, max: 90.0 } },
    lon: { $float: { min: -180.0, max: 180.0 } },
  },
  activity: {
    $choose: {
      from: [
        "Received",
        "AtOrigin",
        "InCustoms",
        "InTransit",
        "AtDestinationWarehouse",
        "OutOnDelivery",
        "Delivered",
        "Exception",
        "Returned",
      ],
    },
  },
  internalActivity: {
    $choose: {
      from: ["yes", "no"],
    },
  },
};

const templatePayment = {
  // unique trackingno passed from delivery
  // _id: trackingno,

  payment: {
    $choose: {
      from: [
        { method: "PayPal", opHash: Buffer.alloc(32) },
        {
          method: "Cash",
          id: { $integer: { min: 1000000, max: 9999999 } },
          address: {
            country: { $country: {} },
            state: { $state: {} },
            city: { $city: {} },
            postcode: { $postcode: {} },
            street: { $street: {} },
            apt: {
              $string: {
                length: { $integer: { min: 5, max: 10 } },
                pool: strPool,
              },
            },
            dept: {
              $choose: {
                from: [
                  null,
                  {
                    $string: {
                      length: { $integer: { min: 5, max: 10 } },
                      pool: strPool,
                    },
                  },
                ],
              },
            },
          },
        },
        {
          method: "Payment Card",
          type: {
            $choose: {
              from: ["debit", "check", "credit"],
            },
          },
          cardno: {
            $integer: { min: 1000000000000000, max: 9999999999999999 },
          },
          exp: "moyr",
          cvv: "cvv",
          address: {
            country: { $country: {} },
            state: { $state: {} },
            city: { $city: {} },
            postcode: { $postcode: {} },
            street: { $street: {} },
            apt: {
              $string: {
                length: { $integer: { min: 5, max: 10 } },
                pool: strPool,
              },
            },
            dept: {
              $choose: {
                from: [
                  null,
                  {
                    $string: {
                      length: { $integer: { min: 5, max: 10 } },
                      pool: strPool,
                    },
                  },
                ],
              },
            },
          },
          vatId: {
            $string: {
              length: { $integer: { min: 10, max: 15 } },
              pool: strPool,
            },
          },
          customerBrokerId: {
            $choose: {
              from: [
                null,
                {
                  $string: {
                    length: { $integer: { min: 4, max: 6 } },
                    pool: strPool,
                  },
                },
              ],
            },
          },
          promoCd: {
            $choose: {
              from: [
                null,
                {
                  $string: {
                    length: 4,
                    pool: strPool,
                  },
                },
              ],
            },
          },
          timestamp: { $date: { min: "2025-01-01", max: "2025-12-31" } },
        },
      ],
    },
  },
};

export { templateDelivery, templateTracking, templatePayment };
