pragma solidity ^0.4.19;

/**
 * Smart contract for the student attestation
 */
contract Attestation {
    uint public universityCount;
    struct University {
        uint id;
        string name;
        string location;
        string email;
        address universityAddr;
        bool isInit;
    }

    uint public studentCount;
    struct Student {
        uint id;
        string name;
        string dob;
        string email;
        string gpa;
        uint universityId;
        address studentAddr;
        bool isInit;
    }

    uint public degreeCount;
    struct Degree {
        uint id;
        uint studentId;
        uint universityId;
        bool verified;
    }

    mapping(address => Student) public students;
    mapping(address => University) public universities;
    mapping(uint => address) private helperMapping;
    mapping(uint => Degree) public degrees;

    /**
     * Adds a new university on the N/w and updates the count.
     */
    function addUniversity(string name, string location, string email) public {
        require(!universities[msg.sender].isInit, "Address already has a university registered.");
        universityCount++;
        helperMapping[universityCount] = msg.sender;
        universities[msg.sender] = University(
            universityCount, name, location, email, msg.sender, true
        );
    }

    /**
     * Adds a new student on the N/w and updates the count.
     */
    function addStudent(string name, string dob, string email, string gpa, uint universityId) public {
        require(!students[msg.sender].isInit, "Address already has a student registered.");
        studentCount++;
        students[msg.sender] = Student(
            studentCount, name, dob, email, gpa, universityId, msg.sender, true
        );
        addDegree(studentCount, universityId);
    }

    /**
     * Adds a new degree that is awaiting approval
     */
    function addDegree(uint studentId, uint universityId) private {
        degreeCount++;
        degrees[degreeCount] = Degree(
            degreeCount, studentId, universityId, false
        );
    }

    /**
     * Approves a pending degree by setting the verified flag to true.
     */
    function verifyDegree(uint degreeId) public {
        require(msg.sender == helperMapping[degrees[degreeId].universityId], "Not authenticated to verify this degree.");
        require(!degrees[degreeId].verified, "Degree is already verified!");
        degrees[degreeId].verified = true;
    }
}