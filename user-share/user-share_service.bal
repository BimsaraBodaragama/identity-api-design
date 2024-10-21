import ballerina/http;

@http:ServiceConfig {basePath: "/t/carbon.super/api/server/v1"}
type OASServiceType service object {
    *http:ServiceContract;
    resource function post users/share(@http:Payload users_share_body payload) returns ProcessSuccessResponseAccepted|ErrorBadRequest|ErrorInternalServerError;
    resource function post users/unshare(@http:Payload users_unshare_body payload) returns ProcessSuccessResponseAccepted|ErrorBadRequest|ErrorInternalServerError;
    resource function get users/[string userId]/shared\-organizations(string? after, string? before, int? 'limit, string? filter, boolean recursive = false) returns UserSharedOrganizationsResponse|ErrorBadRequest|ErrorInternalServerError;
    resource function get users/[string userId]/shared\-roles(string orgId, string? after, string? before, int? 'limit, string? filter, boolean? recursive) returns UserSharedRolesResponse|ErrorBadRequest|ErrorInternalServerError;
};

# Represents a user role within a specific audience (organization or application), defined by its display name and audience type.
public type RoleWithAudience record {
    # Display name of the role
    string displayName;
    RoleWithAudience_audience audience;
};

# Contains a list of user IDs to be unshared.
public type UserUnshareInSelectiveRequestBody_userCriteria record {
    # List of user IDs.
    string[] userIds?;
};

public type ProcessSuccessResponseAccepted record {|
    *http:Accepted;
    ProcessSuccessResponse body;
|};

# The request body for sharing users with specific organizations, specifying roles for each organization.
# Includes a list of users and specific organizations with roles.
public type UserShareInSelectiveRequestBody record {
    UserShareInGeneralRequestBody_userCriteria userCriteria;
    # List of specific organizations specifying sharing scope and roles.
    UserShareInSelectiveRequestBody_organizations[] organizations;
};

public type UserSharedOrganizationsResponse_links record {
    # URL to navigate to the next or previous page.
    string href?;
    # Indicates if the link is for the "next" or "previous" page.
    string rel?;
};

# Details of an error, including code, message, description, and a trace ID to help with debugging.
public type Error record {
    # An error code.
    string code;
    # An error message.
    string message;
    # An error description.
    string description?;
    # A trace ID in UUID format to help with debugging.
    string traceId;
};

public type ErrorBadRequest record {|
    *http:BadRequest;
    Error body;
|};

# The request body for sharing users across all organizations with common roles.
# Includes a list of users, sharing policy, and roles.
public type UserShareInGeneralRequestBody record {
    UserShareInGeneralRequestBody_userCriteria userCriteria;
    # The sharing policy that defines the scope.
    "ALL EXISTING ORGS"|"ALL EXISTING ORGS AND FUTURE ORGS"|"ONLY EXISTING IMMEDIATE ORGS"|"ONLY EXISTING IMMEDIATE ORGS AND FUTURE IMMEDIATE ORGS" policy;
    # A list of roles shared across all organizations.
    RoleWithAudience[] roles?;
};

public type users_unshare_body UserUnshareInSelectiveRequestBody|UserUnshareInGeneralRequestBody;

# The request body for unsharing users from multiple organizations.
# Includes a list of user IDs and a list of organization IDs.
public type UserUnshareInSelectiveRequestBody record {
    UserUnshareInSelectiveRequestBody_userCriteria userCriteria?;
    # List of organization IDs from which the users should be unshared.
    string[] organizations?;
};

# Response listing organizations where a user has shared access, including sharing policies and pagination links for navigating results.
public type UserSharedOrganizationsResponse record {
    # Flag to indicate if the user is shared with all organizations.
    boolean shareWithAllOrgs?;
    # Pagination links for navigating the result set.
    UserSharedOrganizationsResponse_links[] links?;
    # A list of shared access details for the user across multiple organizations
    UserSharedOrganizationsResponse_sharedOrganizations[] sharedOrganizations?;
};

# The request body for unsharing users from all organizations.
# Includes a list of user IDs.
public type UserUnshareInGeneralRequestBody record {
    UserUnshareInSelectiveRequestBody_userCriteria userCriteria?;
};

# Response showing the roles assigned to a user within a specific organization, with pagination support for large role sets.
public type UserSharedRolesResponse record {
    # Pagination links for navigating the result set.
    UserSharedOrganizationsResponse_links[] links?;
    # A list of roles with audience details
    RoleWithAudience[] roles?;
};

# Indicates that the sharing or unsharing process has started successfully, with the current status and relevant details.
public type ProcessSuccessResponse record {
    # Status of the process.
    string status?;
    # Additional information about the process.
    string details?;
};

public type UserSharedOrganizationsResponse_sharedOrganizations record {
    # ID of the child organization
    string orgId?;
    # Name of the child organization
    string orgName?;
    # ID of the shared user
    string sharedUserId?;
    # The scope of sharing for this organization.
    "THIS ORG ONLY"|"THIS ORG AND ALL CHILDREN OF THIS ORG"|"THIS ORG AND ALL EXISTING AND FUTURE CHILDREN" policy?;
    # URL reference to retrieve paginated roles for the shared user in this organization
    string rolesRef?;
};

public type ErrorInternalServerError record {|
    *http:InternalServerError;
    Error body;
|};

public type UserShareInSelectiveRequestBody_organizations record {
    # The ID of the organization to share the users with.
    string orgId;
    # The scope of sharing for this organization.
    "THIS ORG ONLY"|"THIS ORG AND ALL CHILDREN OF THIS ORG"|"THIS ORG AND ALL EXISTING AND FUTURE CHILDREN" policy;
    # A list of roles to be shared with the organization.
    RoleWithAudience[] roles?;
};

public type RoleWithAudience_audience record {
    # Display name of the audience
    string display;
    # Type of the audience, e.g., 'organization' or 'application'
    string 'type;
};

public type users_share_body UserShareInGeneralRequestBody|UserShareInSelectiveRequestBody;

# Contains a list of user IDs to be shared.
public type UserShareInGeneralRequestBody_userCriteria record {
    # List of user IDs.
    string[] userIds?;
};
