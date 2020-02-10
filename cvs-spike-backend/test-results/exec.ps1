
function Write-ColorOutput($ForegroundColor)
{
    # save the current color
    $fc = $host.UI.RawUI.ForegroundColor

    # set the new color
    $host.UI.RawUI.ForegroundColor = $ForegroundColor

    # output
    if ($args) {
        Write-Output $args
    }
    else {
        $input | Write-Output
    }

    # restore the original color
    $host.UI.RawUI.ForegroundColor = $fc
}

Write-Output ""

Write-ColorOutput darkgreen ("########################################")
Write-ColorOutput darkgreen ("        Exec: Lambda::test-results      ")
Write-ColorOutput darkgreen ("########################################")

aws lambda invoke --region=eu-west-2 --function-name=test-results results.txt

Write-ColorOutput darkgreen ("")
Write-ColorOutput darkgreen ("########################################")
Write-ColorOutput darkgreen ("                 Results                ");
Write-ColorOutput darkgreen ("########################################")

Get-Content results.txt

Write-Output ""