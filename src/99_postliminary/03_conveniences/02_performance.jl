struct PerformanceConfiguration <: ConvenienceConfiguration
    sonar_type::SonarType
end

struct Performance2D <: ConvenienceConfiguration
    prop::Propagation2D
end