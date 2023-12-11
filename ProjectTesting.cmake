set(PROJECT_TESTING "")

if(PROJECT_IS_TOP_LEVEL OR ${PROJECT_NAME}_TESTING)
    include(CTest)

    if(BUILD_TESTING)
        set(PROJECT_TESTING ON)
    endif()
endif()
