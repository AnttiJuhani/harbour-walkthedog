/*
 * Copyright (C) 2014 Antti Aura
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *   * Neither the name of the author nor the
 *     names of its contributors may be used to endorse or promote products
 *     derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

.import QtQuick.LocalStorage 2.0 as SQL


// Get connection to the local database
function connectDB() {
    return SQL.LocalStorage.openDatabaseSync("WalkTheDog", "1.0", "Walk The Dog database", 100000);
}

// Drop current database
function dropDB() {
    var db = connectDB();
    db.transaction(
        function(tx) {
            tx.executeSql("DROP TABLE walks");
        }
    );
    console.log("Local database dropped");
}

// Initialize database
function initializeDB() {
    var db = connectDB();
    db.transaction(
        function(tx) {
            // Create the task and list tables
            tx.executeSql("CREATE TABLE IF NOT EXISTS walks(startTime INTEGER, endTime INTEGER, duration INTEGER);");
        }
    );
    console.log("Local database initialized");
}

// Read from database
function readDB(owner, days) {
    var db = connectDB();
    owner.clearWalks(days);

    var startTime = getUnixTime();
    startTime = startTime-(days*86400);

    db.transaction(
        function(tx) {
            var result = tx.executeSql("SELECT * FROM walks WHERE startTime >= ? ORDER BY startTime DESC;", [startTime]);
            for(var i = 0; i < result.rows.length; i++) {
                owner.addWalk(result.rows.item(i).startTime, result.rows.item(i).endTime, result.rows.item(i).duration);
            }
        }
    );
    console.log("Read from DB");
    owner.summarize();
}

// Write into database
function writeDB(startTime, endTime, duration) {
    var db = connectDB();
    try {
        db.transaction(
            function(tx) {
                tx.executeSql("INSERT INTO walks VALUES (?, ?, ?);", [startTime, endTime, duration]);
                tx.executeSql("COMMIT;");
                console.log("Write into DB");
            }
        );
    } catch (sqlErr) {
    }
}

// Get current time, seconds since 1st January 1970 00:00:00Z
function getUnixTime() {
    var time = new Date().getTime();
    return (time / 1000);
}

// Purge rows older than 31 days
function purgeDB() {
    var db = connectDB();

    var maxAge=getUnixTime();
    maxAge = maxAge-(31*86400);

    db.transaction(
        function(tx) {
            var result = tx.executeSql("DELETE FROM walks WHERE startTime < ?;", [maxAge]);
            console.log("Local database purged");
        }
    );
}

// Count database items
function sum(startTime) {
    var sum=0;
    var db = connectDB();
    db.transaction(
        function(tx) {
            var result = tx.executeSql("SELECT COUNT(*) AS rowSum FROM walks WHERE startTime >= ?;", [startTime]);
            if (result.rows.length > 0) {
                sum=result.rows.item(0).rowSum;
            }
        }
    );
    console.log(sum);
    return sum;
}

// Fill database with test data
function fillTestData() {
    var db = connectDB();
    try {
        db.transaction(
            function(tx) {
                for (var i = -40; i < 0; i = i+1) {
                    var start = getUnixTime()+i*10000;
                    var end = getUnixTime()+i*10000+60+i;
                    var duration = 7200+i*340;
                    tx.executeSql("INSERT INTO walks VALUES (?, ?, ?);", [start, end, duration]);
                }
                tx.executeSql("COMMIT;");
                console.log("Database populated");
            }
        );
    } catch (sqlErr) {
    }
}
