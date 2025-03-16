classdef SolarSystemFactory
    %SOLARSYSTEMFACTORY factory for celestial bodies of the solar system
    % the initial positions and velocities are consistent with their
    % relative positions and velocities in the solar system. This means all
    % all celestial bodies created with this factory can be directly used
    % in a simulation
    % note that the gravitational constant is set to 1! hence the mass-unit
    % must be adjusted when setting the simulation-parameters
    % all other parameters use SI-units!

    properties (Constant)
        %Sun
        posXsun = 0;
        posYsun = 0;
        velXsun = 0;
        velYsun = 0;
        massSun = 1.989 * 10^30 * 6.6743*10^-11;
        densitySun = 1.408 * 10^3 * 6.6743*10^-11;

        %Earth
        posXearth = 152.1 * 10^9;
        posYearth = 0;
        velXearth = 0;
        velYearth = 29290;
        massEarth = 5.9722 * 10^24 * 6.6743*10^-11;
        densityEarth = 5.51 * 10^3 * 6.6743*10^-11;

        %Moon
        posXmoon = 152.1 * 10^9 + 0.3844 * 10^9;
        posYmoon = 0;
        velXmoon = 0;
        velYmoon = 29290 + 1100;
        massMoon = 7.346 * 10^22 * 6.6743*10^-11;
        densityMoon = 5.51 * 10^3 * 6.6743*10^-11;

        %Jupiter
        posXjupiter = 740.595 * 10^9;
        posYjupiter = 0;
        velXjupiter = 0;
        velYjupiter = 13069;
        massJupiter = 1.89813 * 10^27 * 6.6743*10^-11;
        densityJupiter = 1.33 * 10^3 * 6.6743*10^-11;

        %Io
        posXio = 740.595 * 10^9 + 0.4218 * 10^9;
        posYio = 0;
        velXio = 0;
        velYio = 13069 + 17334;
        massIo = 8.93193797 * 10^22 * 6.6743*10^-11;
        densityIo = 3.528 * 10^3 * 6.6743*10^-11;

        %Ganymede
        posXganymede = 740.595 * 10^9 + 1.0715 * 10^9;
        posYganymede = 0;
        velXganymede = 0;
        velYganymede = 13069 + 10880;
        massGanymede = 1.4819 * 10^23 * 6.6743*10^-11;
        densityGanymede = 1.936 * 10^3 * 6.6743*10^-11;

        %Kallisto
        posXkallisto = 740.595 * 10^9 + 1.8959 * 10^9;
        posYkallisto = 0;
        velXkallisto = 0;
        velYkallisto = 13069 + 8200;
        massKallisto = 1.0759 * 10^23 * 6.6743*10^-11;
        densityKallisto = 1.830 * 10^3 * 6.6743*10^-11;

        %Europa
        posXeuropa = 740.595 * 10^9 + 0.6771 * 10^9;
        posYeuropa = 0;
        velXeuropa = 0;
        velYeuropa = 13069 + 13740;
        massEuropa = 4.8 * 10^22 * 6.6743*10^-11;
        densityEuropa = 3.01 * 10^3 * 6.6743*10^-11;
    end

    methods
        function obj = SolarSystemFactory()
            %SOLARSYSTEMFACTORY Construct an instance of this class
        end
        
        function massSphere = createSun(obj)
            %CREATESUN creates a SphericalMass with data of the Sun
            massSphere = SphericalMass(obj.posXsun, obj.posYsun, obj.velXsun, obj.velYsun, obj.massSun, obj.densitySun);
        end

        function massSphere = createEarth(obj)
            %CREATEEARTH creates a SphericalMass with data of Earth
            massSphere = SphericalMass(obj.posXearth, obj.posYearth, obj.velXearth, obj.velYearth, obj.massEarth, obj.densityEarth);
        end

        function massSphere = createMoon(obj)
            %CREATEMOON creates a SphericalMass with data of the Moon
            massSphere = SphericalMass(obj.posXmoon, obj.posYmoon, obj.velXmoon, obj.velYmoon, obj.massMoon, obj.densityMoon);
        end

        function massSphere = createJupiter(obj)
            %CREATEJUPITER creates a SphericalMass with data of Jupiter
            massSphere = SphericalMass(obj.posXjupiter, obj.posYjupiter, obj.velXjupiter, obj.velYjupiter, obj.massJupiter, obj.densityJupiter);
        end

        function massSphere = createIo(obj)
            %CREATEIO creates a SphericalMass with data of Io
            massSphere = SphericalMass(obj.posXio, obj.posYio, obj.velXio, obj.velYio, obj.massIo, obj.densityIo);
        end

        function massSphere = createGanymede(obj)
            %CREATEIGANYMEDE creates a SphericalMass with data of Ganymede
            massSphere = SphericalMass(obj.posXganymede, obj.posYganymede, obj.velXganymede, obj.velYganymede, obj.massGanymede, obj.densityGanymede);
        end

        function massSphere = createKallisto(obj)
            %CREATEIKALLISTO creates a SphericalMass with data of Kallisto
            massSphere = SphericalMass(obj.posXkallisto, obj.posYkallisto, obj.velXkallisto, obj.velYkallisto, obj.massKallisto, obj.densityKallisto);
        end

        function massSphere = createEuropa(obj)
            %CREATEIEUROPA creates a SphericalMass with data of Europa
            massSphere = SphericalMass(obj.posXeuropa, obj.posYeuropa, obj.velXeuropa, obj.velYeuropa, obj.massEuropa, obj.densityEuropa);
        end
    end
end

