public class CTRL02_GoogleReview {
    public List<Review>                  reviews         {get;set;}

    public class Review {
        public String                    reviewId        {get;set;}
        public String                    authorName      {get;set;}
        public List<Comment>             comments        {get;set;}
    }

    public class Comment {
       public UserComment userComment  {get;set;}
    }

    public class UserComment {
        public Integer                  starRating        {get;set;}
        public String                   reviewerLanguage  {get;set;}
        public String                   device            {get;set;}
        public String                   appVersionCode    {get;set;}
        public String                   appVersionName    {get;set;}
        public String                   text              {get;set;}
        public LastModified             lastModified      {get;set;}
        public DeviceMetadata           deviceMetadata    {get;set;}
    }

    public class LastModified {
        public String                   seconds           {get;set;}
        public String                   nanos             {get;set;}
    }

    public class DeviceMetadata {
        public String                   productName       {get;set;}
        public String                   manufacturer      {get;set;}
        public String                   deviceClass       {get;set;}
        public String                   nativePlatform    {get;set;}
        public String                   cpuModel          {get;set;}
        public String                   cpuMake           {get;set;}
    }
}