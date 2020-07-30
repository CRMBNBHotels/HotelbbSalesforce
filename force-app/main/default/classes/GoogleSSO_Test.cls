@isTest
public class GoogleSSO_Test {
    
    @isTest
    public static void testCreateAndUpdateUser() {
        
        GoogleSSO handler = new GoogleSSO();
        Auth.UserData sampleData = new Auth.UserData('testId', 'testFirst', 'testLast',
                                                     'testFirst testLast', 'omar.bensouda.ext@hotelbb.com', null, 'testuserlong', 'en_US', 'google',
                                                     null, new Map<String, String>{'language' => 'en_US'});
        User u = handler.createUser('0SO1v00000006od', sampleData);
        update (u);
        String uid = u.id;
        
        sampleData = new Auth.UserData('testNewId', 'testNewFirst', 'testNewLast',
                                       'testNewFirst testNewLast', 'testnewuser@example.org', null, 'testnewuserlong', 'en_US', 'google',
                                       null, new Map<String, String>{});
        handler.updateUser(uid, null, sampleData);
        
        User updatedUser = [SELECT userName, email, firstName, lastName, alias FROM user WHERE id=:uid];
    }
    

}