class APSAccountData {
  [System.Security.Principal.SecurityIdentifier] $SID
  [String] $Surname
  [String] $GivenName
  [String] $Nickname
  [string] $SamAccountName
  [String] $Position
  [String] $Department
  [String] $Building
  [Bool] $AHS
  [Bool] $ELL
  [Bool] $IJH
  [Bool] $BAN
  [Bool] $NEV
  [Bool] $SOU
  [Bool] $SUM
  [Bool] $WOO
  [Bool] $CLC
  [Bool] $OAK
  [Bool] $PAE
  [Bool] $RIV

  APSAccountData () {
  }

  APSAccountData ([String]$FirstName, [String]$LastName, [String] $Nickname, [String]$Position, `
      [String]$Department, [String]$Building, [Bool] $AHS, [Bool] $ELL, [Bool] $IJH, [Bool] $BAN, [Bool] $NEV,
    [Bool] $SOU, [Bool] $SUM, [Bool] $WOO, [Bool] $CLC, [Bool] $OAK, [Bool] $PAE, [Bool] $RIV
  ) {
    $this.GivenName = $FirstName;
    $this.Surname = $LastName;
    $this.Nickname = $Nickname
    $this.Position = $Position;
    $this.Department = $Department;
    $this.Building = $Building;
    $this.AHS = $AHS;
    $this.ELL = $ELL;
    $this.IJH = $IJH;
    $this.BAN = $BAN;
    $this.NEV = $NEV;
    $this.SOU = $SOU;
    $this.SUM = $SUM;
    $this.WOO = $WOO;
    $this.CLC = $CLC;
    $this.OAK = $OAK;
    $this.PAE = $PAE;
    $this.RIV = $RIV;
  }

  APSAccountData (  [System.Security.Principal.SecurityIdentifier] $SID, `
      [System.Guid] $GUID, [String]$FirstName, [String]$LastName, [String] $Nickname, `
      [String]$Position, [String]$Department, [String]$Building, [Bool] $AHS, [Bool] $ELL, [Bool] $IJH, [Bool] $BAN, [Bool] $NEV,
    [Bool] $SOU, [Bool] $SUM, [Bool] $WOO, [Bool] $CLC, [Bool] $OAK, [Bool] $PAE, [Bool] $RIV
  ) {
    $this.SID = $SID
    $this.GUID = $GUID
    $this.GivenName = $FirstName;
    $this.Surname = $LastName;
    $this.Nickname = $Nickname
    $this.Position = $Position;
    $this.Department = $Department;
    $this.Building = $Building;
    $this.AHS = $AHS;
    $this.ELL = $ELL;
    $this.IJH = $IJH;
    $this.BAN = $BAN;
    $this.NEV = $NEV;
    $this.SOU = $SOU;
    $this.SUM = $SUM;
    $this.WOO = $WOO;
    $this.CLC = $CLC;
    $this.OAK = $OAK;
    $this.PAE = $PAE;
    $this.RIV = $RIV;
  }

}
