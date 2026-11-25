
classdef SocialAgent < handle

    properties
        ID
        HasSeen
        Trust
        SharingPropensity
        ParentID
        ExposureTime
    end

    methods
        function obj = SocialAgent(id, trust, sharingPropensity)

            obj.ID = id;
            obj.HasSeen = false;
            obj.Trust = trust;
            obj.SharingPropensity = sharingPropensity;
            obj.ParentID = 0;
            obj.ExposureTime = inf;

        end
    end

end
