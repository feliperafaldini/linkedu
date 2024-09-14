const functions = require("firebase-functions");
const neo4j = require("neo4j-driver");

const driver = neo4j.driver("neo4j+s://3a9a20be.databases.neo4j.io",
    neo4j.auth.basic("neo4j", "dn247sLQrXsruyE7s44ThKPbosQ1qb-ex2BV4vWbn5c"));

exports.addNode = functions.https.onCall(async (data, context) => {
    const session = driver.session();
    try {
        const {nodeName, nodeType} = data;
        const query = "CREATE (n:Node {name: $nodeName, type: $nodeType})RETURN n";

        const result = await session.run(query,
            {nodeName: nodeName, nodeType: nodeType});

        await session.close();

        return {
            message: "Node adicionada com sucesso",
            node: result.records[0].get("n"),
        };
    } catch (error) {
        await session.close();

        throw new functions.https.HttpsError("internal", error.message);
    }
});
