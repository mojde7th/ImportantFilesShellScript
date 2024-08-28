#!/bin/bash

# Prompt for version input
echo "Enter version (e.g., 1.0.0): "
read version

# Set up parameters with version and date-time (without seconds)
base_name="important_files"
timestamp=$(date +"%Y%m%d_%H%M")
output_folder="${base_name}_v${version}_${timestamp}"
zip_file="${output_folder}.zip"
included_files_list="included_files_list_v${version}_${timestamp}.txt"
included_files_content="included_files_content_v${version}_${timestamp}.txt"

# Define the output directory, two paths before the root directory
output_path="../../${output_folder}"

# Create output directory
mkdir -p "$output_path"

# List of exact files to exclude
exclude_files=(
"./src/todo-app-frontend/src/App.test.js"
"./src/todo-app-frontend/src/reportWebVitals.js"
"./src/todo-app-frontend/src/setupTests.js"
"./src/TodoApp.Application/TodoAppApplicationModule.cs"
"./src/TodoApp.Application.Contracts/TodoAppApplicationContractsModule.cs"
"./src/TodoApp.Application.Contracts/TodoAppDtoExtensions.cs"
"./src/TodoApp.DbMigrator/DbMigratorHostedService.cs"
"./src/TodoApp.DbMigrator/Program.cs"
"./src/TodoApp.DbMigrator/TodoAppDbMigratorModule.cs"
"./src/TodoApp.Domain/TodoAppDomainModule.cs"
"./src/TodoApp.Domain.Shared/Localization/TodoAppResource.cs"
"./src/TodoApp.Domain.Shared/MultiTenancy/MultiTenancyConsts.cs"
"./src/TodoApp.Domain.Shared/TodoAppDomainErrorCodes.cs"
"./src/TodoApp.Domain.Shared/TodoAppDomainSharedModule.cs"
"./src/TodoApp.Domain.Shared/TodoAppGlobalFeatureConfigurator.cs"
"./src/TodoApp.Domain.Shared/TodoAppModuleExtensionConfigurator.cs"
"./src/TodoApp.EntityFrameworkCore/EntityFrameworkCore/EntityFrameworkCoreTodoAppDbSchemaMigrator.cs"
"./src/TodoApp.EntityFrameworkCore/EntityFrameworkCore/TodoAppDbContextFactory.cs"
"./src/TodoApp.EntityFrameworkCore/EntityFrameworkCore/TodoAppEfCoreEntityExtensionMappings.cs"
"./src/TodoApp.EntityFrameworkCore/EntityFrameworkCore/TodoAppEntityFrameworkCoreModule.cs"
"./src/TodoApp.HttpApi/TodoAppHttpApiModule.cs"
"./src/TodoApp.HttpApi.Client/TodoAppHttpApiClientModule.cs"
"./src/TodoApp.Web/abp.resourcemapping.js"
"./src/TodoApp.Web/TodoAppBrandingProvider.cs"
"./todo-app-frontend/build/static/js/453.b4f84c2c.chunk.js"
"./todo-app-frontend/build/static/js/main.75d09222.js"
"./todo-app-frontend/src/App.test.js"
"./todo-app-frontend/src/reportWebVitals.js"
"./todo-app-frontend/src/setupTests.js"
)

# Convert exclude_files array to grep patterns
exclude_patterns=$(printf "|%s" "${exclude_files[@]}")
exclude_patterns=${exclude_patterns:1}  # Remove the leading '|'

# Find and list the important files, excluding unnecessary files, directories, and the specified exact files
find . -type f \
    \( -name "*.cs" -o -name "*.js" \) \
    ! -path "*/node_modules/*" \
    ! -path "*/bin/*" \
    ! -path "*/obj/*" \
    ! -path "*/Migrations/*" \
    ! -path "*/test/*" \
    ! -path "*/.git/*" \
    ! -path "*/.github/*" \
    ! -path "*/Properties/*" \
    ! -path "*/DbMigrator/*" \
    ! -path "*/Permissions/*" \
    ! -path "*/Data/*" \
    ! -path "*/OpenIddict/*" \
    ! -path "*/Settings/*" \
    ! -path "*/Shared/*" \
    ! -path "*/Models/*" \
    ! -path "*/Client/*" \
    ! -path "*/Menus/*" \
    ! -path "*/Pages/*" \
    ! -name "*.csproj" \
    ! -name "*.sh" \
    ! -name "*.json" \
    | grep -Ev "$exclude_patterns" > "$output_path/$included_files_list"

# Create a text file with the content of all included files
> "$output_path/$included_files_content"
while IFS= read -r file; do
    if [[ -f "$file" ]]; then
        echo "=== $file ===" >> "$output_path/$included_files_content"
        cat "$file" >> "$output_path/$included_files_content"
        echo -e "\n\n" >> "$output_path/$included_files_content"
    fi
done < "$output_path/$included_files_list"

# Copy the included files to the output folder
while IFS= read -r file; do
    mkdir -p "$(dirname "$output_path/$file")"
    cp "$file" "$output_path/$file"
done < "$output_path/$included_files_list"

# Zip the entire output folder
cd "$output_path/.."
zip -r "$zip_file" "$output_folder"

# Move back to the original directory
cd - > /dev/null

echo "Zipped important files and saved in: $zip_file"
echo "Included files list saved in: $included_files_list"
echo "Content of included files saved in: $included_files_content"
