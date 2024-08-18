export propagation_loss

function propagation_loss(p::Complex)
    -20log10(p |> abs)
end
