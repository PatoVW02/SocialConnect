import SwiftUI

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.shared
    }
}

class DeveloperPreview {
    static let shared = DeveloperPreview()
    
    var post = Post(
        id: "65271f83b994e6e82eedc0e4",
        organization: Organization(
            id: "65263953d45fed8455675e77",
            userId: "6510eb3c13e234b63bde1692",
            name: "test name",
            userName: "test userName",
            rfc: "ASDF8245QFH",
            schedule: "9am-5pm",
            address: Organization.Address(
                street1: "test",
                street2: "test",
                city: "test",
                state: "test",
                zipCode: "test",
                country: "mexico"
            ),
            contact: Organization.Contact(
                phoneNumber: "test",
                email: "test"
            ),
            description: "test",
            socialNetworks: [Organization.SocialNetwork(name: "Facebook", url: "www.facebook.com")],
            logoUrl: "https://gmvykon.com/wp-content/uploads/2021/05/Frisa-logo-400x400-1.jpg",
            videoUrl: "https://www.youtube.com/watch?v=SoJ-L9peEIQ",
            bannerUrl: "https://drive.google.com/uc?export=view&id=1wC7mtwNGiWVO24ciX3DQmI0lTS6QZiPn",
            tags: ["6510b9fb078006769df6cb0c"],
            createdAt: Date.now,
            updatedAt: Date.now
        ),
        title: "Test post title",
        postType: "Test post type",
        content: "ñalksjdfñlaskjdfñlkasjdfñlkjsadl jsañldk jsaldkfjsahfaskdjf lñksjfl sajdf ñasj fñ jsdlfk jasdkf jñalsdfj ",
        videoUrl: "https://drive.google.com/uc?export=view&id=1VUbButsjmVOGIIcgV9Rynzb36WN1mEJA",
        createdAt: Date.now
    )
    
    var user = User(
        id: "String",
        email: "patovw@gmail.com",
        firstName: "Patricio",
        lastName: "Villarreal",
        phoneNumber: "8115914144",
        role: "Admin",
        imageUrl: "",
        isFollowed: true
    )
    
    var organization = Organization(
        id: "65263953d45fed8455675e77",
        userId: "test2",
        name: "Frisa",
        userName: "Frisa",
        rfc: "ASDFKASD72752H",
        schedule: "9am-5pm",
        address: Organization.Address(
            street1: "street1",
            street2: "street2",
            city: "city",
            state: "state",
            zipCode: "zipCode",
            country: "country"
        ),
        contact: Organization.Contact(
            phoneNumber: "phone",
            email: "email"
        ),
        description: "desc",
        socialNetworks: [Organization.SocialNetwork(
            name: "instagram",
            url: "www.instagram.com"
        )],
        logoUrl: "https://static.guiaongs.org/wp-content/uploads/2015/09/so%C3%B1ar-despierto-360x336.jpg",
        videoUrl: "https://www.youtube.com/watch?v=SoJ-L9peEIQ",
        bannerUrl: "https://drive.google.com/uc?export=view&id=1ZWhn-zlCy3ZsS7gNcE0-b_JLxxhPFjkJ",
        tags: ["6510b9fb078006769df6cb0c"],
        createdAt: Date(),
        updatedAt: Date()
    )
    
    var favorite = Favorite(
        id: "652ccd41ee8a03f827ff8ec3",
        organizationId: "65263953d45fed8455675e77",
        userId: "65263562d45fed8455675e61",
        name: "asdalskdjfñlaksjdfñlaksjdfñlaksjdfñlaksdjflñkasjdfñlksadjflñksjdff",
        rfc: "asdf",
        schedule: "5am a 9pm",
        userName: "asdf",
        address: Favorite.Address(
            street1: "asdf",
            street2: "asdf",
            city: "asdf",
            state: "asdf",
            zipCode: "asdf",
            country: "asdf"
        ),
        contact: Favorite.Contact(
            phoneNumber: "asdf",
            email: "asdf"
        ),
        description: "asdf",
        socialNetworks: [Favorite.SocialNetwork(name: "asdf", url: "asdf")],
        logoUrl: "",
        videoUrl: "",
        bannerUrl: "",
        tags: ["asdf"],
        createdAt: Date.now,
        updatedAt: Date.now
    )
    
    var tag = Tag(id: NSUUID().uuidString, name: "Autismo", description: "Discapacidad", createdAt: Date(), updatedAt: Date(), updatedBy: "You")
}
